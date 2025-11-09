# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2025_11_09_023325) do
  create_table "accounts", force: :cascade do |t|
    t.string "base_currency"
    t.datetime "created_at", null: false
    t.string "institution"
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "adjustments", force: :cascade do |t|
    t.integer "adjustment_type", null: false
    t.decimal "amount", precision: 20, scale: 8
    t.datetime "created_at", null: false
    t.date "effective_date"
    t.integer "lot_id", null: false
    t.json "metadata"
    t.text "notes"
    t.datetime "updated_at", null: false
    t.index ["lot_id"], name: "index_adjustments_on_lot_id"
  end

  create_table "assets", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "currency"
    t.string "display_name"
    t.integer "security_type", null: false
    t.string "ticker"
    t.datetime "updated_at", null: false
  end

  create_table "audit_events", force: :cascade do |t|
    t.integer "action", null: false
    t.string "actor"
    t.json "after"
    t.json "before"
    t.datetime "created_at", null: false
    t.integer "entity_id"
    t.string "entity_type"
    t.datetime "updated_at", null: false
  end

  create_table "imports", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "error_log"
    t.string "filename"
    t.json "payload"
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
  end

  create_table "lots", force: :cascade do |t|
    t.integer "account_id", null: false
    t.integer "asset_id", null: false
    t.datetime "created_at", null: false
    t.decimal "fees", precision: 20, scale: 8
    t.text "notes"
    t.decimal "quantity", precision: 20, scale: 8
    t.date "settle_date"
    t.json "tags"
    t.date "trade_date"
    t.decimal "unit_cost", precision: 20, scale: 8
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_lots_on_account_id"
    t.index ["asset_id"], name: "index_lots_on_asset_id"
  end

  create_table "price_sources", force: :cascade do |t|
    t.string "adapter_type"
    t.datetime "created_at", null: false
    t.json "credentials"
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "sale_allocations", force: :cascade do |t|
    t.json "cost_basis_snapshot"
    t.datetime "created_at", null: false
    t.integer "lot_id", null: false
    t.decimal "quantity", precision: 20, scale: 8
    t.decimal "realized_pl", precision: 20, scale: 8
    t.integer "sale_id", null: false
    t.datetime "updated_at", null: false
    t.index ["lot_id"], name: "index_sale_allocations_on_lot_id"
    t.index ["sale_id"], name: "index_sale_allocations_on_sale_id"
  end

  create_table "sales", force: :cascade do |t|
    t.integer "account_id", null: false
    t.integer "asset_id", null: false
    t.datetime "created_at", null: false
    t.decimal "fees", precision: 20, scale: 8
    t.decimal "proceeds", precision: 20, scale: 8
    t.decimal "total_quantity", precision: 20, scale: 8
    t.date "trade_date"
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_sales_on_account_id"
    t.index ["asset_id"], name: "index_sales_on_asset_id"
  end

  create_table "valuations", force: :cascade do |t|
    t.datetime "as_of"
    t.integer "asset_id", null: false
    t.datetime "created_at", null: false
    t.integer "lot_id", null: false
    t.json "metrics"
    t.decimal "price", precision: 20, scale: 8
    t.string "source"
    t.datetime "updated_at", null: false
    t.index ["asset_id"], name: "index_valuations_on_asset_id"
    t.index ["lot_id"], name: "index_valuations_on_lot_id"
  end

  add_foreign_key "adjustments", "lots"
  add_foreign_key "lots", "accounts"
  add_foreign_key "lots", "assets"
  add_foreign_key "sale_allocations", "lots"
  add_foreign_key "sale_allocations", "sales"
  add_foreign_key "sales", "accounts"
  add_foreign_key "sales", "assets"
  add_foreign_key "valuations", "assets"
  add_foreign_key "valuations", "lots"
end
