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

ActiveRecord::Schema[7.1].define(version: 2024_02_08_173601) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string "quicknode_id", null: false
    t.string "plan_slug", null: false
    t.boolean "is_test", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "discarded_at"
    t.index ["discarded_at"], name: "index_accounts_on_discarded_at"
    t.index ["quicknode_id"], name: "index_accounts_on_quicknode_id"
  end

  create_table "endpoints", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.string "quicknode_id", null: false
    t.string "chain", null: false
    t.string "network", null: false
    t.string "wss_url"
    t.string "http_url", null: false
    t.boolean "is_test", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "discarded_at"
    t.index ["account_id"], name: "index_endpoints_on_account_id"
    t.index ["discarded_at"], name: "index_endpoints_on_discarded_at"
    t.index ["quicknode_id"], name: "index_endpoints_on_quicknode_id"
  end

  create_table "users", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.string "email"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "discarded_at"
    t.string "organization_name"
    t.index ["account_id"], name: "index_users_on_account_id"
    t.index ["discarded_at"], name: "index_users_on_discarded_at"
  end

  add_foreign_key "endpoints", "accounts"
  add_foreign_key "users", "accounts"
end
