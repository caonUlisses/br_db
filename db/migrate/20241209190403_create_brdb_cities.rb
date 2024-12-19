class CreateBrdbCities < ActiveRecord::Migration[8.0]
  def change
    create_table :br_db_cities do |t|
      t.string :name
      t.string :code
      t.string :state_id, null: false

      t.timestamps
    end
  end
end
