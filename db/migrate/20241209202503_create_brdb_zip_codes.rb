class CreateBrdbZipCodes < ActiveRecord::Migration[8.0]
  def change
    create_table :brdb_zip_codes do |t|
      t.string :zip_code
      t.string :street_name
      t.string :street_additional_info
      t.string :neighborhood_name
      t.string :city_name
      t.string :city_code
      t.string :state_code
      t.string :name

      t.timestamps
    end
  end
end
