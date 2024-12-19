class CreateBrdbCountries < ActiveRecord::Migration[8.0]
  def change
    create_table :br_db_countries do |t|
      t.string :name
      t.string :iso_2
      t.string :iso_3

      t.timestamps
    end
  end
end
