module Brdb
  class LoadStatesJob < ApplicationJob
    queue_as :default

    def perform(*args)
      resp = HTTParty.get("https://servicodados.ibge.gov.br/api/v1/localidades/estados")
      states = JSON.parse(resp.body).map do |entry|
        {
          id: entry["id"],
          name: entry["nome"],
          code: entry["sigla"]
        }
      end
      State.insert_all(states)
    end
  end
end
