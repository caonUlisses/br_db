module BrDb
  class ImportStatesController < ApplicationController
    def create
      LoadStatesJob.perform_later
      render json: { message: "States are being imported" }
    end
  end
end
