module BrDb
  class LoadCitiesJob < ApplicationJob
    queue_as :default

    def perform(*args)
      resp = HTTParty.get("https://servicodados.ibge.gov.br/api/v1/localidades/municipios")
      cities = JSON.parse(resp.body).map do |entry|
        {
          id: entry["id"],
          name: entry["nome"],
          state_id: entry["microrregiao"]["mesorregiao"]["UF"]["id"]
        }
      end
      City.insert_all(cities)
    end
  end
end
