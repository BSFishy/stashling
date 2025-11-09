class CreateLots < ActiveRecord::Migration[8.1]
  def change
    create_table :lots do |t|
      t.references :asset, null: false, foreign_key: true
      t.references :account, null: false, foreign_key: true
      t.date :trade_date
      t.date :settle_date
      t.decimal :quantity, precision: 20, scale: 8
      t.decimal :unit_cost, precision: 20, scale: 8
      t.decimal :fees, precision: 20, scale: 8
      t.json :tags
      t.text :notes

      t.timestamps
    end
  end
end
