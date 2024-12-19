# This migration comes from br_db (originally 20241210130730)
class CreateBrdbCnaes < ActiveRecord::Migration[8.0]
  def change
    create_table :br_db_cnaes do |t|
      t.string :code
      t.string :description

      t.timestamps
    end
  end
end
