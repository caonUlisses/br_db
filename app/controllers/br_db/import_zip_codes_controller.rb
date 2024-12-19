module BrDb
  class ImportZipCodesController < ApplicationController
    def create
      LoadZipCodesJob.perform_later
      render json: { message: "Zip codes are being imported" }
    end
  end
end
