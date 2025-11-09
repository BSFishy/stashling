class DropInvestments < ActiveRecord::Migration[8.1]
  def change
    drop_table :investments do |t|
      t.string :ticker
      t.float :amount

      t.timestamps
    end
  end
end
