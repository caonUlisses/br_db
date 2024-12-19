# This migration comes from br_db (originally 20241210125732)
class CreateBrdbCompanies < ActiveRecord::Migration[8.0]
  def change
    create_table :br_db_companies do |t|
      t.string :cnpj
      t.string :name
      t.string :legal_name
      t.datetime :since
      t.string :main_cnae
      t.string :secondary_cnae
      t.string :street_name
      t.string :address_number
      t.string :address_additional_info
      t.string :neighborhood_name
      t.string :zip_code
      t.string :state_code
      t.string :city_name
      t.string :main_phone
      t.string :secondary_phone
      t.string :additional_phone
      t.string :email

      t.timestamps
    end
  end
end
