require "zip"
require "down"
require "csv"
require "fileutils"

module BrDb
  class LoadCompaniesJob < ApplicationJob
    queue_as :default

    BASE_URL = "https://arquivos.receitafederal.gov.br/dados/cnpj/dados_abertos_cnpj/"
    RESOURCES = [ "Cnaes" ] # TODO: enable "Estabelecimentos" again
    DELIMITER = ";"
    ENCODING = "iso-8859-1:utf-8"
    QUOTE_CHARS = %w[" | ~ ^ & *]

    def perform(*args)
      RESOURCES.each do |resource|
        download_files(resource)
        unzip_files(resource)
        load(resource)
        # cleanup(resource)
      end
    end

    private

    def load(prefix)
      case prefix
      when "Cnaes"
        load_cnaes
      when "Estabelecimentos"
        load_companies
      end
    end

    def download_files(prefix)
      urls = get_urls(prefix.titleize)
      puts "Found the following URLs: #{urls}"
      urls.each_with_index do |url, i|
        destination = FileUtils.makedirs(Rails.root.join("tmp", prefix))
        tmp_file_path = destination.join(prefix)  + "/#{i}.zip"
        next if File.exist?(tmp_file_path)
        Down.download(
          url,
          destination: tmp_file_path
        )
        puts "Downloaded #{prefix} #{i}"
      rescue Down::Error => e
        puts "Failed to download #{prefix} #{i}: #{e.message}"
      end
    end


    def cleanup(resource)
      FileUtils.rm_rf(Rails.root.join("tmp", resource))
    end

    def unzip_files(prefix)
      tmp_file_path = Rails.root.join("tmp", prefix)

      i = 0
      Dir.foreach(tmp_file_path) do |file|
        next if file == "." || file == ".." || !file.end_with?(".zip")
        file_path = tmp_file_path.join(file)
        Zip::File.open(file_path) do |zip_file|
          zip_file.each_with_index do |entry|
            next if File.exist?(tmp_file_path.join("#{i}.csv"))
            entry.extract(tmp_file_path.join("#{i}.csv"))
          end
        end
        i += 1
      end
    end

    def load_companies
      Company.delete_all
      tmp_file_path = Rails.root.join("tmp", "Estabelecimentos")
      companies = []
      Dir.foreach(tmp_file_path) do |file|
        puts "PROCESSING #{file}"
        next if file == "." || file == ".." || !file.end_with?(".csv")
        file_path = tmp_file_path.join(file)
        CSV.foreach(file_path, liberal_parsing: true, col_sep: DELIMITER, headers: false, encoding: ENCODING, quote_char: QUOTE_CHARS.shift) do |row|
          companies << {
            cnpj: row[0] + row[1] + row[2],
            name: row[4],
            since: row[10],
            main_cnae: row[11],
            secondary_cnae: row[12],
            street_name: row[13] + " " + row[14],
            address_number: row[15],
            address_additional_info: row[16],
            neighborhood_name: row[17],
            zip_code: row[18],
            state_code: row[19],
            city_name: row[20],
            main_phone: row[21] + row[22],
            secondary_phone: row[23] + row[24],
            additional_phone: row[25] + row[26],
            email: row[27]
          }
          if companies.count % 30_000 == 0
            Company.insert_all(companies)
            companies = []
          end
        end
        Company.insert_all(companies)
      end
    end

    def load_cnaes
      Cnae.delete_all
      tmp_file_path = Rails.root.join("tmp", "Cnaes")
      cnaes = []
      Dir.foreach(tmp_file_path) do |file|
        next if file == "." || file == ".." || !file.end_with?(".csv")
        file_path = tmp_file_path.join(file)
        CSV.foreach(file_path, liberal_parsing: true, col_sep: DELIMITER, headers: false, encoding: ENCODING, quote_char: QUOTE_CHARS.shift) do |row|
          cnaes << { code: row[0], description: row[1] }
        end
      end

      Cnae.insert_all(cnaes)
    end

    def get_current_month_url
      resp = HTTParty.get(BASE_URL)
      return [] unless resp.code == 200

      html = resp.body
      doc = Nokogiri::HTML(html)
      href = doc.css("tr")[-2].css("a").first["href"]
      if href.starts_with?("temp")
        href = doc.css("tr")[-3].css("a").first["href"]
      end
      BASE_URL + href
    end

    def get_urls(prefix)
      current_month_url = get_current_month_url
      resp = HTTParty.get(current_month_url)
      return [] unless resp.code == 200

      doc = Nokogiri::HTML(resp.body)
      urls = doc.css("a")
      urls.map do |url|
        next unless url.text.starts_with?(prefix.titleize)
        current_month_url + url["href"]
      end.compact
    end
  end
end
