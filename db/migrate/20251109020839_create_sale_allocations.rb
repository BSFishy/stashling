class CreateSaleAllocations < ActiveRecord::Migration[8.1]
  def change
    create_table :sale_allocations do |t|
      t.references :sale, null: false, foreign_key: true
      t.references :lot, null: false, foreign_key: true
      t.decimal :quantity, precision: 20, scale: 8
      t.decimal :realized_pl, precision: 20, scale: 8
      t.json :cost_basis_snapshot

      t.timestamps
    end
  end
end
