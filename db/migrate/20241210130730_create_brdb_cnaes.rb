class CreateBrdbCnaes < ActiveRecord::Migration[8.0]
  def change
    create_table :brdb_cnaes do |t|
      t.string :code
      t.string :description

      t.timestamps
    end
  end
end
