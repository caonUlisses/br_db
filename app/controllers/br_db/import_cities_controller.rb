module BrDb
  class ImportCitiesController < ApplicationController
    def create
      LoadCitiesJob.perform_later
      render json: { message: "Cities are being imported" }
    end
  end
end
