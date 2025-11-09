class CreateValuations < ActiveRecord::Migration[8.1]
  def change
    create_table :valuations do |t|
      t.references :asset, null: false, foreign_key: true
      t.references :lot, null: false, foreign_key: true
      t.decimal :price, precision: 20, scale: 8
      t.datetime :as_of
      t.string :source
      t.json :metrics

      t.timestamps
    end
  end
end
