module BrDb
  class ImportCompaniesController < ApplicationController
    def create
      LoadCompaniesJob.perform_later
      render json: { message: "Companies are being imported" }
    end
  end
end
