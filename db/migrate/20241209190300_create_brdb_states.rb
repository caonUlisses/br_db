class CreateBrdbStates < ActiveRecord::Migration[8.0]
  def change
    create_table :brdb_states do |t|
      t.string :name
      t.string :code

      t.timestamps
    end
  end
end
