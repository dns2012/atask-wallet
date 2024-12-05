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

ActiveRecord::Schema[8.0].define(version: 2024_12_01_020959) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "user_balance_histories", force: :cascade do |t|
    t.bigint "user_wallet_id", null: false
    t.integer "balance_type", default: 0
    t.integer "balance_amount", default: 0
    t.bigint "user_transaction_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_transaction_id"], name: "index_user_balance_histories_on_user_transaction_id"
    t.index ["user_wallet_id"], name: "index_user_balance_histories_on_user_wallet_id"
  end

  create_table "user_transactions", force: :cascade do |t|
    t.bigint "source_user_wallet_id"
    t.bigint "target_user_wallet_id"
    t.integer "transaction_type", default: 0
    t.integer "transaction_amount", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["source_user_wallet_id"], name: "index_user_transactions_on_source_user_wallet_id"
    t.index ["target_user_wallet_id"], name: "index_user_transactions_on_target_user_wallet_id"
  end

  create_table "user_wallets", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "balance", default: 0
    t.string "wallet_alias"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_wallets_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.string "token_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "user_balance_histories", "user_transactions"
  add_foreign_key "user_balance_histories", "user_wallets"
  add_foreign_key "user_transactions", "user_wallets", column: "source_user_wallet_id"
  add_foreign_key "user_transactions", "user_wallets", column: "target_user_wallet_id"
  add_foreign_key "user_wallets", "users"
end
