class CreateInvestments < ActiveRecord::Migration[8.0]
  def change
    create_table :investments do |t|
      t.string :ticker
      t.float :amount

      t.timestamps
    end
  end
end
