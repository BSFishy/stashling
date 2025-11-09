class CreateAuditEvents < ActiveRecord::Migration[8.1]
  def change
    create_table :audit_events do |t|
      t.string :entity_type
      t.integer :entity_id
      t.integer :action, null: false
      t.json :before
      t.json :after
      t.string :actor

      t.timestamps
    end
  end
end
