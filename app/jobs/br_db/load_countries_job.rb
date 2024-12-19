require "json"
require "httparty"

module BrDb
  class LoadCountriesJob < ApplicationJob
    queue_as :default

    def perform(*args)
      resp = HTTParty.get("https://servicodados.ibge.gov.br/api/v1/localidades/paises")
      countries = JSON.parse(resp.body).map do |json_body|
        {
          name: json_body["nome"],
          id: json_body["id"]["M49"],
          iso_2: json_body["id"]["ISO-ALPHA-2"],
          iso_3: json_body["id"]["ISO-ALPHA-3"]
        }
      end
      Country.insert_all(countries)
    end
  end
end
