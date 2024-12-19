require "zip"
require "csv"
require "fileutils"

module BrDb
  class LoadZipCodesJob < ApplicationJob
    queue_as :default

    ENCODING = "iso-8859-1:utf-8"
    DELIMITER = "@"
    QUOTE_CHARS = %w[" | ~ ^ & *]
    INNER_FILE_PATH = Rails.root.join("tmp", "dne_inner.zip")
    TMP_FILE_PATH = Rails.root.join("tmp", "dne.zip")
    DELIMITADO_FILE_PATH = Rails.root.join("tmp", "dne_csv/delimitado")

    def perform(*args)
      download_dne_file
      unzip_dne_file
      unzip_csv_folder
      import_zip_codes
      import_city_zip_codes
      cleanup
    end

    def cleanup
      ZipCode.where(zip_code: nil).delete_all
      File.delete(TMP_FILE_PATH) if File.exist?(TMP_FILE_PATH)
      File.delete(INNER_FILE_PATH) if File.exist?(INNER_FILE_PATH)
      FileUtils.rm_rf(DELIMITADO_FILE_PATH)
    end

    private

    def download_dne_file
      # Check if the file is already downloaded
      return if File.exist?(TMP_FILE_PATH)

      response = HTTParty.get("https://www2.correios.com.br/sistemas/edne/download/eDNE_Basico.zip")
      if response.code == 200
        File.open(TMP_FILE_PATH, "wb") { |file|file.write(response.body) }
      else
        puts "Failed to download file: HTTP #{response.code}"
      end
    end

    def unzip_dne_file
      return if File.exist?(INNER_FILE_PATH)
      Zip::File.open(TMP_FILE_PATH) do |zip_file|
        zip_file.sort_by(&:size).reverse!
        zip_file.first.extract(INNER_FILE_PATH)
      end
    end

    def unzip_csv_folder
      destination = FileUtils.makedirs(Rails.root.join("tmp", "dne_csv"))
      Zip::File.open(INNER_FILE_PATH) do |zip_file|
        zip_file.entries.select { |entry| entry.name.start_with?("Delimitado/") }.each do |entry|
          entry_path = destination.join(entry.name) + "/#{entry.name.downcase}"

          # Ensure directory exists
          FileUtils.mkdir_p(File.dirname(entry_path))

          # Extract the file
          entry.extract(entry_path) unless File.exist?(entry_path)
        end
      end
    end

    def import_zip_codes
      # The file name is log_logradouro_SC.txt or log_logradouro_SP.txt
      csv_file_path_regex = /log_logradouro_(\w\w).txt/
      path = DELIMITADO_FILE_PATH
      city_mapping = get_data_map("log_localidade.txt", 2, 8)
      neighborhood_mapping = get_data_map("log_bairro.txt", 3, 3)

      # iterate over the csv files that match the regex pattern
      Dir.glob(path.join("**", "*.txt")).each do |file_path|
        zip_codes = []
        next unless csv_file_path_regex.match?(file_path)
        CSV.foreach(file_path, liberal_parsing: true, col_sep: DELIMITER, headers: false, encoding: ENCODING, quote_char: QUOTE_CHARS.shift) do |row|
          street_name = row[8] + " " + row[5]
          zip_codes << {
            state_code: row[1],
            neighborhood_name: neighborhood_mapping[row[3]],
            street_name: street_name,
            city_name: city_mapping[row[2]][0],
            city_code: city_mapping[row[2]][1],
            street_additional_info: row[6],
            zip_code: row[7]
          }
        end
        ZipCode.insert_all(zip_codes)
      end
    end

    def import_city_zip_codes
      city_file_path = DELIMITADO_FILE_PATH + "log_localidade.txt"

      zip_codes = []
      CSV.foreach(city_file_path, liberal_parsing: true, col_sep: DELIMITER, headers: false, encoding: ENCODING, quote_char: QUOTE_CHARS.shift) do |row|
        zip_codes << {
          state_code: row[1],
          city_name: row[2],
          city_code: row[8],
          zip_code: row[3]
        }
      end
      ZipCode.insert_all(zip_codes)
    end

    def get_data_map(file_path, first_key, second_key)
      file_path = DELIMITADO_FILE_PATH + file_path
      mapping = {}

      CSV.foreach(file_path, liberal_parsing: true, col_sep: DELIMITER, headers: false, encoding: ENCODING, quote_char: QUOTE_CHARS.shift) do |row|
        mapping[row[0]] = [ row[first_key], row[second_key] ]
      end
      mapping
    end
  end
end
