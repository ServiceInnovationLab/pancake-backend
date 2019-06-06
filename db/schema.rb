# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_05_30_021728) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "batches", force: :cascade do |t|
    t.float "amount"
    t.integer "claim_count"
    t.text "download_link"
    t.bigint "council_id"
    t.datetime "batch_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.index ["council_id"], name: "index_batches_on_council_id"
  end

  create_table "councils", force: :cascade do |t|
    t.string "name"
    t.string "short_name"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "email"
  end

  create_table "properties", force: :cascade do |t|
    t.text "valuation_id"
    t.text "location"
    t.text "suburb"
    t.text "town_city"
    t.text "meta"
    t.integer "council_id"
    t.text "rating_year"
    t.index ["council_id"], name: "index_properties_on_council_id"
    t.index ["valuation_id", "rating_year"], name: "index_properties_on_valuation_id_and_rating_year"
  end

  create_table "rates_bills", force: :cascade do |t|
    t.integer "property_id"
    t.text "rating_year"
    t.text "order"
    t.text "current_owner_start_date"
    t.text "meta"
    t.decimal "total_rates", precision: 8, scale: 2
    t.decimal "total_water_rates", precision: 8, scale: 2
    t.index ["property_id", "rating_year"], name: "index_rates_bills_on_property_id_and_rating_year", unique: true
  end

  create_table "rates_payers", force: :cascade do |t|
    t.integer "property_id"
    t.text "council_owner_id"
    t.text "surname"
    t.text "first_names"
    t.text "meta"
  end

  create_table "rebate_forms", force: :cascade do |t|
    t.string "valuation_id"
    t.string "token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.json "fields"
    t.integer "property_id"
    t.decimal "rebate", precision: 8, scale: 2
    t.integer "batch_id"
    t.integer "updated_by"
    t.string "status", default: "not signed"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name", null: false
    t.string "friendly_name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_roles_on_name", unique: true
  end

  create_table "roles_users", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "role_id", null: false
    t.index ["role_id"], name: "index_roles_users_on_role_id"
    t.index ["user_id"], name: "index_roles_users_on_user_id"
  end

  create_table "signature_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_signature_types_on_name", unique: true
  end

  create_table "signatures", force: :cascade do |t|
    t.bigint "signature_type_id"
    t.bigint "rebate_form_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.binary "image"
    t.text "name"
    t.text "role"
    t.index ["rebate_form_id"], name: "index_signatures_on_rebate_form_id"
    t.index ["signature_type_id"], name: "index_signatures_on_signature_type_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer "invitation_limit"
    t.string "invited_by_type"
    t.bigint "invited_by_id"
    t.integer "invitations_count", default: 0
    t.datetime "deactivated_at"
    t.integer "council_id"
    t.string "name"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true
    t.index ["invitations_count"], name: "index_users_on_invitations_count"
    t.index ["invited_by_id"], name: "index_users_on_invited_by_id"
    t.index ["invited_by_type", "invited_by_id"], name: "index_users_on_invited_by_type_and_invited_by_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "rates_bills", "properties"
  add_foreign_key "rates_payers", "properties"
  add_foreign_key "rebate_forms", "batches"
  add_foreign_key "rebate_forms", "properties"
  add_foreign_key "rebate_forms", "users", column: "updated_by"
  add_foreign_key "signatures", "rebate_forms"
  add_foreign_key "signatures", "signature_types"
end
