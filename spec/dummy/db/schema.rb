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

ActiveRecord::Schema[7.2].define(version: 2025_09_08_173000) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"
  enable_extension "tsm_system_rows"

  create_table "accounts", force: :cascade do |t|
    t.bigint "registration_id"
    t.integer "balance", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["registration_id"], name: "index_accounts_on_registration_id"
  end

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
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "area"
    t.string "site_suffix"
    t.index ["registration_id", "address_type", "site_suffix"], name: "index_addresses_on_registration_type_suffix"
    t.index ["registration_id"], name: "index_addresses_on_registration_id"
  end

  create_table "analytics_page_views", force: :cascade do |t|
    t.string "page"
    t.datetime "time"
    t.string "route"
    t.bigint "user_journey_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_journey_id"], name: "index_analytics_page_views_on_user_journey_id"
  end

  create_table "analytics_user_journeys", force: :cascade do |t|
    t.string "journey_type"
    t.datetime "completed_at"
    t.string "token"
    t.string "user"
    t.string "started_route"
    t.string "completed_route"
    t.text "registration_data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "band_charge_details", force: :cascade do |t|
    t.bigint "band_id"
    t.integer "initial_compliance_charge_amount", default: 0
    t.integer "additional_compliance_charge_amount", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "charge_detail_id"
    t.index ["charge_detail_id"], name: "index_band_charge_details_on_charge_detail_id"
  end

  create_table "bands", force: :cascade do |t|
    t.string "name", null: false
    t.integer "sequence"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "beta_participants", force: :cascade do |t|
    t.string "reg_number"
    t.string "email"
    t.string "token"
    t.datetime "invited_at"
    t.boolean "opted_in"
    t.string "registration_type"
    t.bigint "registration_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "selected_payment_method"
    t.index ["registration_type", "registration_id"], name: "index_beta_participants_on_registration"
  end

  create_table "bucket_exemptions", force: :cascade do |t|
    t.bigint "bucket_id"
    t.bigint "exemption_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bucket_id"], name: "index_bucket_exemptions_on_bucket_id"
    t.index ["exemption_id"], name: "index_bucket_exemptions_on_exemption_id"
  end

  create_table "buckets", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "bucket_type"
    t.index ["bucket_type"], name: "index_buckets_on_bucket_type", unique: true
    t.index ["name"], name: "index_buckets_on_name", unique: true
  end

  create_table "charge_adjustments", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.integer "amount", null: false
    t.string "adjustment_type", null: false
    t.string "reason", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_charge_adjustments_on_account_id"
  end

  create_table "charge_details", force: :cascade do |t|
    t.integer "registration_charge_amount"
    t.integer "bucket_charge_amount", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "order_id"
    t.integer "total_charge_amount"
    t.index ["order_id"], name: "index_charge_details_on_order_id"
  end

  create_table "charges", force: :cascade do |t|
    t.string "name", null: false
    t.string "charge_type", null: false
    t.integer "charge_amount", null: false
    t.string "chargeable_type"
    t.bigint "chargeable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["charge_type"], name: "index_charges_on_charge_type"
    t.index ["chargeable_type", "chargeable_id"], name: "index_charges_on_chargeable"
  end

  create_table "communication_logs", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "message_type"
    t.string "template_id"
    t.string "template_label"
    t.string "sent_to"
  end

  create_table "companies", force: :cascade do |t|
    t.string "name"
    t.string "company_no", null: false
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_no"], name: "index_companies_on_company_no", unique: true
  end

  create_table "ea_public_face_areas", force: :cascade do |t|
    t.string "area_id", null: false
    t.string "name", null: false
    t.string "code", null: false
    t.geometry "area", limit: {:srid=>0, :type=>"geometry"}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["area"], name: "index_ea_public_face_areas_on_area", using: :gist
    t.index ["area_id"], name: "index_ea_public_face_areas_on_area_id", unique: true
    t.index ["code"], name: "index_ea_public_face_areas_on_code"
  end

  create_table "exemptions", id: :serial, force: :cascade do |t|
    t.integer "category"
    t.string "code"
    t.string "url"
    t.string "summary"
    t.text "description"
    t.text "guidance"
    t.boolean "hidden", default: false
    t.bigint "band_id"
    t.bigint "waste_activity_id"
    t.index ["band_id"], name: "index_exemptions_on_band_id"
    t.index ["waste_activity_id"], name: "index_exemptions_on_waste_activity_id"
  end

  create_table "feature_toggles", force: :cascade do |t|
    t.string "key"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "order_buckets", force: :cascade do |t|
    t.bigint "order_id"
    t.bigint "bucket_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bucket_id"], name: "index_order_buckets_on_bucket_id"
    t.index ["order_id"], name: "index_order_buckets_on_order_id"
  end

  create_table "order_exemptions", force: :cascade do |t|
    t.bigint "order_id"
    t.bigint "exemption_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["exemption_id"], name: "index_order_exemptions_on_exemption_id"
    t.index ["order_id"], name: "index_order_exemptions_on_order_id"
  end

  create_table "orders", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "order_owner_type"
    t.bigint "order_owner_id"
    t.string "order_uuid"
    t.index ["order_owner_type", "order_owner_id"], name: "index_orders_on_order_owner"
  end

  create_table "payments", force: :cascade do |t|
    t.string "payment_type"
    t.integer "payment_amount"
    t.string "payment_status"
    t.bigint "order_id"
    t.datetime "date_time"
    t.string "govpay_id"
    t.string "refunded_payment_govpay_id"
    t.boolean "moto_payment", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "payment_uuid"
    t.bigint "account_id"
    t.string "reference"
    t.string "comments", limit: 500
    t.string "created_by"
    t.integer "associated_payment_id"
    t.index ["account_id"], name: "index_payments_on_account_id"
    t.index ["associated_payment_id"], name: "index_payments_on_associated_payment_id"
    t.index ["order_id"], name: "index_payments_on_order_id"
  end

  create_table "people", id: :serial, force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.integer "person_type"
    t.integer "registration_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["registration_id"], name: "index_people_on_registration_id"
  end

  create_table "registration_communication_logs", force: :cascade do |t|
    t.bigint "registration_id"
    t.bigint "communication_log_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["communication_log_id"], name: "index_registration_communication_logs_on_communication_log_id"
    t.index ["registration_id"], name: "index_registration_communication_logs_on_registration_id"
  end

  create_table "registration_exemptions", id: :serial, force: :cascade do |t|
    t.string "state"
    t.date "registered_on"
    t.date "expires_on"
    t.integer "registration_id"
    t.integer "exemption_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.text "deregistration_message"
    t.date "deregistered_at"
    t.string "reason_for_change", limit: 500
    t.bigint "address_id"
    t.index ["address_id"], name: "index_registration_exemptions_on_address_id"
    t.index ["exemption_id"], name: "index_registration_exemptions_on_exemption_id"
    t.index ["registration_id"], name: "index_active_registration_ids_on_registration_exemptions", where: "((state)::text = 'active'::text)"
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
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.date "submitted_at"
    t.string "assistance_mode"
    t.string "renew_token"
    t.integer "referring_registration_id"
    t.datetime "companies_house_updated_at", precision: nil
    t.datetime "deregistration_email_sent_at", precision: nil
    t.string "edit_token"
    t.datetime "edit_token_created_at"
    t.boolean "reminder_opt_in", default: true
    t.string "unsubscribe_token"
    t.boolean "charged", default: false
    t.string "view_certificate_token"
    t.datetime "view_certificate_token_created_at"
    t.boolean "placeholder", default: false
    t.string "reason_for_change", limit: 500
    t.string "edit_link_requested_by"
    t.index ["created_at"], name: "index_registrations_on_created_at"
    t.index ["deregistration_email_sent_at"], name: "index_registrations_on_deregistration_email_sent_at"
    t.index ["edit_token"], name: "index_registrations_on_edit_token", unique: true
    t.index ["placeholder"], name: "index_registrations_on_placeholder"
    t.index ["reference"], name: "index_registrations_on_reference", unique: true
    t.index ["renew_token"], name: "index_registrations_on_renew_token", unique: true
    t.index ["unsubscribe_token"], name: "index_registrations_on_unsubscribe_token", unique: true
  end

  create_table "reports_downloads", force: :cascade do |t|
    t.string "report_type"
    t.string "report_file_name"
    t.string "user_id"
    t.datetime "downloaded_at"
  end

  create_table "reports_generated_reports", id: :serial, force: :cascade do |t|
    t.string "file_name"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.date "data_from_date"
    t.date "data_to_date"
    t.string "report_type", default: "bulk", null: false
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
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "area"
    t.string "site_suffix"
    t.index ["transient_registration_id", "address_type", "site_suffix"], name: "index_transient_addresses_on_registration_type_suffix"
    t.index ["transient_registration_id"], name: "index_transient_addresses_on_transient_registration_id"
  end

  create_table "transient_people", id: :serial, force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.integer "person_type"
    t.integer "transient_registration_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["transient_registration_id"], name: "index_transient_people_on_transient_registration_id"
  end

  create_table "transient_registration_exemptions", id: :serial, force: :cascade do |t|
    t.string "state"
    t.date "registered_on"
    t.date "expires_on"
    t.integer "transient_registration_id"
    t.integer "exemption_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "transient_address_id"
    t.index ["exemption_id"], name: "index_transient_registration_exemptions_on_exemption_id"
    t.index ["transient_address_id"], name: "index_transient_registration_exemptions_on_transient_address_id"
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
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "type", null: false
    t.boolean "temp_renew_without_changes"
    t.boolean "temp_reuse_applicant_phone"
    t.boolean "temp_reuse_applicant_email"
    t.boolean "temp_reuse_operator_address"
    t.string "temp_reuse_address_for_site_location"
    t.boolean "temp_use_registered_company_details"
    t.datetime "companies_house_updated_at", precision: nil
    t.boolean "temp_reuse_applicant_name"
    t.text "workflow_history", default: [], array: true
    t.string "assistance_mode"
    t.text "excluded_exemptions", default: [], array: true
    t.boolean "temp_confirm_exemption_edits"
    t.boolean "temp_confirm_no_exemption_changes"
    t.boolean "temp_check_your_answers_flow"
    t.string "temp_company_no"
    t.string "temp_payment_method"
    t.text "temp_waste_activities", default: [], array: true
    t.text "temp_exemptions", default: [], array: true
    t.boolean "temp_confirm_exemptions"
    t.boolean "temp_add_additional_non_bucket_exemptions"
    t.string "temp_govpay_next_url"
    t.string "reason_for_change", limit: 500
    t.boolean "is_multisite_registration"
    t.index ["created_at"], name: "index_transient_registrations_on_created_at"
    t.index ["token"], name: "index_transient_registrations_on_token", unique: true
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "invitation_token"
    t.datetime "invitation_created_at", precision: nil
    t.datetime "invitation_sent_at", precision: nil
    t.datetime "invitation_accepted_at", precision: nil
    t.integer "invitation_limit"
    t.integer "invited_by_id"
    t.string "invited_by_type"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at", precision: nil
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.string "session_token"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "role"
    t.boolean "active", default: true
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
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
    t.datetime "created_at", precision: nil
    t.index ["item_type", "item_id"], name: "index_version_archives_on_item_type_and_item_id"
  end

  create_table "versions", id: :serial, force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at", precision: nil
    t.json "json"
    t.jsonb "object_changes"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  create_table "waste_activities", force: :cascade do |t|
    t.string "name"
    t.string "name_gerund"
    t.integer "category"
    t.datetime "created_at", null: false
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
