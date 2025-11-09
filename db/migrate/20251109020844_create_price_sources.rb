class CreatePriceSources < ActiveRecord::Migration[8.1]
  def change
    create_table :price_sources do |t|
      t.string :name
      t.string :adapter_type
      t.json :credentials

      t.timestamps
    end
  end
end
