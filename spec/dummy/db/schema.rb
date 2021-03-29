# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_03_08_160306) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", id: :serial, force: :cascade do |t|
    t.integer "address_type", default: 0
    t.integer "mode", default: 0
    t.string "uprn"
    t.string "organisation"
    t.string "premises"
    t.string "street_address"
    t.string "locality"
    t.string "city"
    t.string "postcode"
    t.float "x"
    t.float "y"
    t.string "coordinate_system"
    t.string "blpu_state_code"
    t.string "postal_address_code"
    t.string "logical_status_code"
    t.string "source_data_type"
    t.string "country_iso"
    t.string "grid_reference"
    t.text "description"
    t.integer "registration_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "area"
    t.index ["registration_id"], name: "index_addresses_on_registration_id"
  end

  create_table "exemptions", id: :serial, force: :cascade do |t|
    t.integer "category"
    t.string "code"
    t.string "url"
    t.string "summary"
    t.text "description"
    t.text "guidance"
  end

  create_table "feature_toggles", force: :cascade do |t|
    t.string "key"
    t.boolean "active"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "people", id: :serial, force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.integer "person_type"
    t.integer "registration_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["registration_id"], name: "index_people_on_registration_id"
  end

  create_table "registration_exemptions", id: :serial, force: :cascade do |t|
    t.string "state"
    t.date "registered_on"
    t.date "expires_on"
    t.integer "registration_id"
    t.integer "exemption_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "deregistration_message"
    t.date "deregistered_at"
    t.index ["exemption_id"], name: "index_registration_exemptions_on_exemption_id"
    t.index ["registration_id"], name: "index_registration_exemptions_on_registration_id"
  end

  create_table "registrations", id: :serial, force: :cascade do |t|
    t.string "reference"
    t.string "location"
    t.string "applicant_first_name"
    t.string "applicant_last_name"
    t.string "applicant_phone"
    t.string "applicant_email"
    t.string "business_type"
    t.string "operator_name"
    t.string "company_no"
    t.string "contact_first_name"
    t.string "contact_last_name"
    t.string "contact_position"
    t.string "contact_phone"
    t.string "contact_email"
    t.boolean "on_a_farm"
    t.boolean "is_a_farmer"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "submitted_at"
    t.string "assistance_mode"
    t.string "renew_token"
    t.integer "referring_registration_id"
    t.index ["reference"], name: "index_registrations_on_reference", unique: true
    t.index ["renew_token"], name: "index_registrations_on_renew_token", unique: true
  end

  create_table "reports_generated_reports", id: :serial, force: :cascade do |t|
    t.string "file_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "data_from_date"
    t.date "data_to_date"
  end

  create_table "transient_addresses", id: :serial, force: :cascade do |t|
    t.integer "address_type", default: 0
    t.integer "mode", default: 0
    t.string "uprn"
    t.string "organisation"
    t.string "premises"
    t.string "street_address"
    t.string "locality"
    t.string "city"
    t.string "postcode"
    t.float "x"
    t.float "y"
    t.string "coordinate_system"
    t.string "blpu_state_code"
    t.string "postal_address_code"
    t.string "logical_status_code"
    t.string "source_data_type"
    t.string "country_iso"
    t.string "grid_reference"
    t.text "description"
    t.integer "transient_registration_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "area"
    t.index ["transient_registration_id"], name: "index_transient_addresses_on_transient_registration_id"
  end

  create_table "transient_people", id: :serial, force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.integer "person_type"
    t.integer "transient_registration_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["transient_registration_id"], name: "index_transient_people_on_transient_registration_id"
  end

  create_table "transient_registration_exemptions", id: :serial, force: :cascade do |t|
    t.string "state"
    t.date "registered_on"
    t.date "expires_on"
    t.integer "transient_registration_id"
    t.integer "exemption_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["exemption_id"], name: "index_transient_registration_exemptions_on_exemption_id"
    t.index ["transient_registration_id"], name: "index_trans_reg_exemptions_on_transient_registration_id"
  end

  create_table "transient_registrations", id: :serial, force: :cascade do |t|
    t.string "token"
    t.string "reference"
    t.string "workflow_state"
    t.string "start_option"
    t.string "location"
    t.string "applicant_first_name"
    t.string "applicant_last_name"
    t.string "applicant_phone"
    t.string "applicant_email"
    t.string "business_type"
    t.string "operator_name"
    t.string "company_no"
    t.string "contact_first_name"
    t.string "contact_last_name"
    t.string "contact_position"
    t.string "contact_phone"
    t.string "contact_email"
    t.boolean "on_a_farm"
    t.boolean "is_a_farmer"
    t.boolean "declaration"
    t.string "temp_operator_postcode"
    t.string "temp_contact_postcode"
    t.string "temp_site_postcode"
    t.string "temp_grid_reference"
    t.text "temp_site_description"
    t.boolean "address_finder_error", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "type", null: false
    t.boolean "temp_renew_without_changes"
    t.index ["token"], name: "index_transient_registrations_on_token", unique: true
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer "invitation_limit"
    t.integer "invited_by_id"
    t.string "invited_by_type"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.string "session_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "role"
    t.boolean "active", default: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  create_table "version_archives", id: :serial, force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_version_archives_on_item_type_and_item_id"
  end

  create_table "versions", id: :serial, force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at"
    t.json "json"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  add_foreign_key "addresses", "registrations"
  add_foreign_key "people", "registrations"
  add_foreign_key "transient_addresses", "transient_registrations"
  add_foreign_key "transient_people", "transient_registrations"
end
