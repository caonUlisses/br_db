module BrDb
  class ImportCountriesController < ApplicationController
    def create
      LoadCountriesJob.perform_later
      render json: { message: "Countries are being imported" }
    end
  end
end
