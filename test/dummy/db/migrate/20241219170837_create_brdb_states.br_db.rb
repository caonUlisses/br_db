# This migration comes from br_db (originally 20241209190300)
class CreateBrdbStates < ActiveRecord::Migration[8.0]
  def change
    create_table :br_db_states do |t|
      t.string :name
      t.string :code

      t.timestamps
    end
  end
end
