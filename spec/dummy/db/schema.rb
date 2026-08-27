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

ActiveRecord::Schema[8.1].define(version: 2026_05_19_173129) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "postgis"
  enable_extension "tsm_system_rows"

  create_table "accounts", force: :cascade do |t|
    t.integer "balance", default: 0, null: false
    t.datetime "created_at", null: false
    t.bigint "registration_id"
    t.datetime "updated_at", null: false
    t.index ["registration_id"], name: "index_accounts_on_registration_id"
  end

  create_table "addresses", id: :serial, force: :cascade do |t|
    t.integer "address_type", default: 0
    t.string "area"
    t.string "blpu_state_code"
    t.string "city"
    t.string "coordinate_system"
    t.string "country_iso"
    t.datetime "created_at", precision: nil, null: false
    t.text "description"
    t.string "grid_reference"
    t.string "locality"
    t.string "logical_status_code"
    t.integer "mode", default: 0
    t.string "organisation"
    t.string "postal_address_code"
    t.string "postcode"
    t.string "premises"
    t.integer "registration_id"
    t.string "site_suffix"
    t.string "source_data_type"
    t.string "street_address"
    t.datetime "updated_at", precision: nil, null: false
    t.string "uprn"
    t.float "x"
    t.float "y"
    t.index ["registration_id", "address_type", "site_suffix"], name: "index_addresses_on_registration_type_suffix"
    t.index ["registration_id"], name: "index_addresses_on_registration_id"
  end

  create_table "analytics_page_views", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "page"
    t.string "route"
    t.datetime "time"
    t.datetime "updated_at", null: false
    t.bigint "user_journey_id"
    t.index ["user_journey_id"], name: "index_analytics_page_views_on_user_journey_id"
  end

  create_table "analytics_user_journeys", force: :cascade do |t|
    t.datetime "completed_at"
    t.string "completed_route"
    t.datetime "created_at", null: false
    t.string "journey_type"
    t.text "registration_data"
    t.string "started_route"
    t.string "token"
    t.datetime "updated_at", null: false
    t.string "user"
  end

  create_table "band_charge_details", force: :cascade do |t|
    t.integer "additional_compliance_charge_amount", default: 0
    t.bigint "band_id"
    t.bigint "charge_detail_id"
    t.datetime "created_at", null: false
    t.integer "initial_compliance_charge_amount", default: 0
    t.datetime "updated_at", null: false
    t.index ["charge_detail_id"], name: "index_band_charge_details_on_charge_detail_id"
  end

  create_table "bands", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.integer "sequence"
    t.datetime "updated_at", null: false
  end

  create_table "beta_participants", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email"
    t.datetime "invited_at"
    t.boolean "opted_in"
    t.string "reg_number"
    t.bigint "registration_id"
    t.string "registration_type"
    t.string "selected_payment_method"
    t.string "token"
    t.datetime "updated_at", null: false
    t.index ["registration_type", "registration_id"], name: "index_beta_participants_on_registration"
  end

  create_table "bucket_exemptions", force: :cascade do |t|
    t.bigint "bucket_id"
    t.datetime "created_at", null: false
    t.bigint "exemption_id"
    t.datetime "updated_at", null: false
    t.index ["bucket_id"], name: "index_bucket_exemptions_on_bucket_id"
    t.index ["exemption_id"], name: "index_bucket_exemptions_on_exemption_id"
  end

  create_table "buckets", force: :cascade do |t|
    t.string "bucket_type"
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
    t.index ["bucket_type"], name: "index_buckets_on_bucket_type", unique: true
    t.index ["name"], name: "index_buckets_on_name", unique: true
  end

  create_table "charge_adjustments", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.string "adjustment_type", null: false
    t.integer "amount", null: false
    t.datetime "created_at", null: false
    t.string "reason", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_charge_adjustments_on_account_id"
  end

  create_table "charge_details", force: :cascade do |t|
    t.integer "bucket_charge_amount", default: 0
    t.datetime "created_at", null: false
    t.bigint "order_id"
    t.integer "registration_charge_amount"
    t.integer "site_count", default: 1
    t.integer "total_charge_amount"
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_charge_details_on_order_id"
  end

  create_table "charges", force: :cascade do |t|
    t.integer "charge_amount", null: false
    t.string "charge_type", null: false
    t.bigint "chargeable_id"
    t.string "chargeable_type"
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["charge_type"], name: "index_charges_on_charge_type"
    t.index ["chargeable_type", "chargeable_id"], name: "index_charges_on_chargeable"
  end

  create_table "communication_logs", force: :cascade do |t|
    t.text "body"
    t.datetime "created_at", null: false
    t.string "message_type"
    t.string "notification_id"
    t.string "sent_to"
    t.string "status", default: "sent"
    t.string "subject"
    t.string "template_id"
    t.string "template_label"
    t.datetime "updated_at", null: false
    t.index ["notification_id"], name: "index_communication_logs_on_notification_id"
  end

  create_table "companies", force: :cascade do |t|
    t.boolean "active"
    t.string "company_no", null: false
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
    t.index ["company_no"], name: "index_companies_on_company_no", unique: true
  end

  create_table "ea_public_face_areas", force: :cascade do |t|
    t.geometry "area", limit: {srid: 0, type: "geometry"}
    t.string "area_id", null: false
    t.string "code", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["area"], name: "index_ea_public_face_areas_on_area", using: :gist
    t.index ["area_id"], name: "index_ea_public_face_areas_on_area_id", unique: true
    t.index ["code"], name: "index_ea_public_face_areas_on_code"
  end

  create_table "exemptions", id: :serial, force: :cascade do |t|
    t.bigint "band_id"
    t.integer "category"
    t.string "code"
    t.text "description"
    t.text "guidance"
    t.boolean "hidden", default: false
    t.string "summary"
    t.string "url"
    t.bigint "waste_activity_id"
    t.index ["band_id"], name: "index_exemptions_on_band_id"
    t.index ["waste_activity_id"], name: "index_exemptions_on_waste_activity_id"
  end

  create_table "feature_toggles", force: :cascade do |t|
    t.boolean "active"
    t.datetime "created_at", null: false
    t.string "key"
    t.datetime "updated_at", null: false
  end

  create_table "order_buckets", force: :cascade do |t|
    t.bigint "bucket_id"
    t.datetime "created_at", null: false
    t.bigint "order_id"
    t.datetime "updated_at", null: false
    t.index ["bucket_id"], name: "index_order_buckets_on_bucket_id"
    t.index ["order_id"], name: "index_order_buckets_on_order_id"
  end

  create_table "order_exemptions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "exemption_id"
    t.bigint "order_id"
    t.datetime "updated_at", null: false
    t.index ["exemption_id"], name: "index_order_exemptions_on_exemption_id"
    t.index ["order_id"], name: "index_order_exemptions_on_order_id"
  end

  create_table "orders", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "order_owner_id"
    t.string "order_owner_type"
    t.string "order_uuid"
    t.datetime "updated_at", null: false
    t.index ["order_owner_type", "order_owner_id"], name: "index_orders_on_order_owner"
  end

  create_table "payments", force: :cascade do |t|
    t.bigint "account_id"
    t.integer "associated_payment_id"
    t.string "comments", limit: 500
    t.datetime "created_at", null: false
    t.string "created_by"
    t.datetime "date_time"
    t.string "govpay_id"
    t.boolean "moto_payment", default: false
    t.bigint "order_id"
    t.integer "payment_amount"
    t.string "payment_status"
    t.string "payment_type"
    t.string "payment_uuid"
    t.string "reference"
    t.string "refunded_payment_govpay_id"
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_payments_on_account_id"
    t.index ["associated_payment_id"], name: "index_payments_on_associated_payment_id"
    t.index ["order_id"], name: "index_payments_on_order_id"
  end

  create_table "people", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.string "first_name"
    t.string "last_name"
    t.integer "person_type"
    t.integer "registration_id"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["registration_id"], name: "index_people_on_registration_id"
  end

  create_table "registration_communication_logs", force: :cascade do |t|
    t.bigint "communication_log_id"
    t.datetime "created_at", null: false
    t.bigint "registration_id"
    t.datetime "updated_at", null: false
    t.index ["communication_log_id"], name: "index_registration_communication_logs_on_communication_log_id"
    t.index ["registration_id"], name: "index_registration_communication_logs_on_registration_id"
  end

  create_table "registration_exemptions", id: :serial, force: :cascade do |t|
    t.bigint "address_id"
    t.datetime "created_at", precision: nil, null: false
    t.date "deregistered_at"
    t.string "deregistered_by"
    t.text "deregistration_message"
    t.integer "exemption_id"
    t.date "expires_on"
    t.string "reason_for_change", limit: 500
    t.date "registered_on"
    t.integer "registration_id"
    t.string "state"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["address_id"], name: "index_registration_exemptions_on_address_id"
    t.index ["exemption_id"], name: "index_registration_exemptions_on_exemption_id"
    t.index ["registration_id"], name: "index_active_registration_ids_on_registration_exemptions", where: "((state)::text = 'active'::text)"
    t.index ["registration_id"], name: "index_registration_exemptions_on_registration_id"
  end

  create_table "registrations", id: :serial, force: :cascade do |t|
    t.string "applicant_email"
    t.string "applicant_first_name"
    t.string "applicant_last_name"
    t.string "applicant_phone"
    t.string "assistance_mode"
    t.string "business_type"
    t.boolean "charged", default: false
    t.boolean "charitable_purpose"
    t.datetime "companies_house_updated_at", precision: nil
    t.string "company_no"
    t.string "contact_email"
    t.string "contact_first_name"
    t.string "contact_last_name"
    t.string "contact_phone"
    t.string "contact_position"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "deregistration_email_sent_at", precision: nil
    t.string "edit_link_requested_by"
    t.string "edit_token"
    t.datetime "edit_token_created_at"
    t.boolean "is_a_farmer"
    t.boolean "is_legacy_bulk", default: false
    t.boolean "is_linear", default: false
    t.boolean "is_multisite_registration"
    t.string "location"
    t.boolean "on_a_farm"
    t.string "operator_name"
    t.boolean "placeholder", default: false
    t.string "reason_for_change", limit: 500
    t.string "reference"
    t.integer "referring_registration_id"
    t.boolean "reminder_opt_in", default: true
    t.string "renew_token"
    t.date "submitted_at"
    t.string "unsubscribe_token"
    t.datetime "updated_at", precision: nil, null: false
    t.string "view_certificate_token"
    t.datetime "view_certificate_token_created_at"
    t.index ["created_at"], name: "index_registrations_on_created_at"
    t.index ["deregistration_email_sent_at"], name: "index_registrations_on_deregistration_email_sent_at"
    t.index ["edit_token"], name: "index_registrations_on_edit_token", unique: true
    t.index ["placeholder"], name: "index_registrations_on_placeholder"
    t.index ["reference"], name: "index_registrations_on_reference", unique: true
    t.index ["renew_token"], name: "index_registrations_on_renew_token", unique: true
    t.index ["unsubscribe_token"], name: "index_registrations_on_unsubscribe_token", unique: true
  end

  create_table "transient_addresses", id: :serial, force: :cascade do |t|
    t.integer "address_type", default: 0
    t.string "area"
    t.string "blpu_state_code"
    t.string "city"
    t.string "coordinate_system"
    t.string "country_iso"
    t.datetime "created_at", precision: nil, null: false
    t.text "description"
    t.string "grid_reference"
    t.string "locality"
    t.string "logical_status_code"
    t.integer "mode", default: 0
    t.string "organisation"
    t.string "postal_address_code"
    t.string "postcode"
    t.string "premises"
    t.string "site_suffix"
    t.string "source_data_type"
    t.string "street_address"
    t.integer "transient_registration_id"
    t.datetime "updated_at", precision: nil, null: false
    t.string "uprn"
    t.float "x"
    t.float "y"
    t.index ["transient_registration_id", "address_type", "site_suffix"], name: "index_transient_addresses_on_registration_type_suffix"
    t.index ["transient_registration_id"], name: "index_transient_addresses_on_transient_registration_id"
  end

  create_table "transient_people", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.string "first_name"
    t.string "last_name"
    t.integer "person_type"
    t.integer "transient_registration_id"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["transient_registration_id"], name: "index_transient_people_on_transient_registration_id"
  end

  create_table "transient_registration_exemptions", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.date "deregistered_at"
    t.string "deregistered_by"
    t.text "deregistration_message"
    t.integer "exemption_id"
    t.date "expires_on"
    t.string "reason_for_change", limit: 500
    t.date "registered_on"
    t.string "state"
    t.bigint "transient_address_id"
    t.integer "transient_registration_id"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["exemption_id"], name: "index_transient_registration_exemptions_on_exemption_id"
    t.index ["transient_address_id"], name: "index_transient_registration_exemptions_on_transient_address_id"
    t.index ["transient_registration_id"], name: "index_trans_reg_exemptions_on_transient_registration_id"
  end

  create_table "transient_registrations", id: :serial, force: :cascade do |t|
    t.boolean "address_finder_error", default: false
    t.string "applicant_email"
    t.string "applicant_first_name"
    t.string "applicant_last_name"
    t.string "applicant_phone"
    t.string "assistance_mode"
    t.string "business_type"
    t.boolean "charitable_purpose"
    t.boolean "charitable_purpose_declaration"
    t.datetime "companies_house_updated_at", precision: nil
    t.string "company_no"
    t.string "contact_email"
    t.string "contact_first_name"
    t.string "contact_last_name"
    t.string "contact_phone"
    t.string "contact_position"
    t.datetime "created_at", precision: nil, null: false
    t.boolean "declaration"
    t.text "excluded_exemptions", default: [], array: true
    t.boolean "is_a_farmer"
    t.boolean "is_legacy_bulk", default: false
    t.boolean "is_linear", default: false
    t.boolean "is_multisite_registration"
    t.string "location"
    t.boolean "on_a_farm"
    t.string "operator_name"
    t.string "reason_for_change", limit: 500
    t.string "reference"
    t.string "start_option"
    t.boolean "temp_check_your_answers_flow"
    t.string "temp_company_no"
    t.boolean "temp_confirm_exemption_edits"
    t.boolean "temp_confirm_exemptions"
    t.boolean "temp_confirm_no_exemption_changes"
    t.string "temp_contact_postcode"
    t.text "temp_exemptions", default: [], array: true
    t.string "temp_govpay_next_url"
    t.string "temp_grid_reference"
    t.string "temp_operator_postcode"
    t.string "temp_payment_method"
    t.boolean "temp_renew_without_changes"
    t.string "temp_reuse_address_for_site_location"
    t.boolean "temp_reuse_applicant_email"
    t.boolean "temp_reuse_applicant_name"
    t.boolean "temp_reuse_applicant_phone"
    t.boolean "temp_reuse_operator_address"
    t.text "temp_site_description"
    t.integer "temp_site_id"
    t.string "temp_site_postcode"
    t.boolean "temp_use_registered_company_details"
    t.text "temp_waste_activities", default: [], array: true
    t.string "token"
    t.string "type", null: false
    t.datetime "updated_at", precision: nil, null: false
    t.text "workflow_history", default: [], array: true
    t.string "workflow_state"
    t.index ["created_at"], name: "index_transient_registrations_on_created_at"
    t.index ["token"], name: "index_transient_registrations_on_token", unique: true
  end

  create_table "version_archives", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.string "event", null: false
    t.integer "item_id", null: false
    t.string "item_type", null: false
    t.text "object"
    t.string "whodunnit"
    t.index ["item_type", "item_id"], name: "index_version_archives_on_item_type_and_item_id"
  end

  create_table "versions", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.string "event", null: false
    t.integer "item_id", null: false
    t.string "item_type", null: false
    t.json "json"
    t.text "object"
    t.jsonb "object_changes"
    t.string "whodunnit"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  create_table "waste_activities", force: :cascade do |t|
    t.integer "category"
    t.datetime "created_at", null: false
    t.string "name"
    t.string "name_gerund"
    t.datetime "updated_at", null: false
  end

  add_foreign_key "accounts", "registrations"
  add_foreign_key "addresses", "registrations"
  add_foreign_key "analytics_page_views", "analytics_user_journeys", column: "user_journey_id"
  add_foreign_key "band_charge_details", "charge_details"
  add_foreign_key "bucket_exemptions", "buckets"
  add_foreign_key "bucket_exemptions", "exemptions"
  add_foreign_key "charge_adjustments", "accounts"
  add_foreign_key "charge_details", "orders"
  add_foreign_key "exemptions", "bands"
  add_foreign_key "order_buckets", "buckets"
  add_foreign_key "order_buckets", "orders"
  add_foreign_key "order_exemptions", "exemptions"
  add_foreign_key "order_exemptions", "orders"
  add_foreign_key "payments", "accounts"
  add_foreign_key "people", "registrations"
  add_foreign_key "registration_exemptions", "addresses", validate: false
  add_foreign_key "transient_addresses", "transient_registrations"
  add_foreign_key "transient_people", "transient_registrations"
  add_foreign_key "transient_registration_exemptions", "transient_addresses", validate: false
end
