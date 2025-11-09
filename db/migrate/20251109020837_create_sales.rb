class CreateSales < ActiveRecord::Migration[8.1]
  def change
    create_table :sales do |t|
      t.references :asset, null: false, foreign_key: true
      t.references :account, null: false, foreign_key: true
      t.date :trade_date
      t.decimal :total_quantity, precision: 20, scale: 8
      t.decimal :proceeds, precision: 20, scale: 8
      t.decimal :fees, precision: 20, scale: 8

      t.timestamps
    end
  end
end
