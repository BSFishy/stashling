class CreateAssets < ActiveRecord::Migration[8.1]
  def change
    create_table :assets do |t|
      t.string :ticker
      t.integer :security_type, null: false
      t.string :currency
      t.string :display_name

      t.timestamps
    end
  end
end
