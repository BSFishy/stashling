class CreateImports < ActiveRecord::Migration[8.1]
  def change
    create_table :imports do |t|
      t.string :filename
      t.integer :status, null: false, default: 0
      t.json :payload
      t.text :error_log

      t.timestamps
    end
  end
end
