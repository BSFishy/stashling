class CreateAdjustments < ActiveRecord::Migration[8.1]
  def change
    create_table :adjustments do |t|
      t.references :lot, null: false, foreign_key: true
      t.integer :adjustment_type, null: false
      t.decimal :amount, precision: 20, scale: 8
      t.date :effective_date
      t.text :notes
      t.json :metadata

      t.timestamps
    end
  end
end
