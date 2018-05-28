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

ActiveRecord::Schema.define(version: 20180528075747) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "pg_trgm"

  create_table "buyer_applications", force: :cascade do |t|
    t.string "state", null: false
    t.integer "buyer_id"
    t.integer "assigned_to_id"
    t.text "application_body"
    t.text "decision_body"
    t.datetime "started_at"
    t.datetime "submitted_at"
    t.datetime "decided_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "manager_name"
    t.string "manager_email"
    t.datetime "manager_approved_at"
    t.string "manager_approval_token"
  end

  create_table "buyers", force: :cascade do |t|
    t.integer "user_id"
    t.string "organisation"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "state", null: false
    t.string "name"
    t.string "employment_status"
  end

  create_table "documents", force: :cascade do |t|
    t.integer "documentable_id", null: false
    t.string "documentable_type", null: false
    t.string "document"
    t.string "kind", null: false
    t.string "scan_status", default: "unscanned", null: false
    t.string "original_filename"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "events", force: :cascade do |t|
    t.integer "eventable_id", null: false
    t.string "eventable_type", null: false
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "type", null: false
    t.string "name"
    t.string "email"
    t.text "note"
  end

  create_table "product_benefits", force: :cascade do |t|
    t.integer "product_id"
    t.string "benefit"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "product_features", force: :cascade do |t|
    t.integer "product_id"
    t.string "feature"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "products", force: :cascade do |t|
    t.integer "seller_id", null: false
    t.string "state", null: false
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "audiences", default: [], array: true
    t.text "summary"
    t.string "section"
    t.string "reseller_type"
    t.string "organisation_resold"
    t.boolean "custom_contact"
    t.string "contact_name"
    t.string "contact_email"
    t.string "contact_phone"
    t.boolean "free_version"
    t.text "free_version_details"
    t.boolean "free_trial"
    t.string "free_trial_url"
    t.decimal "pricing_min"
    t.decimal "pricing_max"
    t.string "pricing_unit"
    t.text "pricing_variables"
    t.string "pricing_calculator_url"
    t.boolean "education_pricing"
    t.text "education_pricing_eligibility"
    t.text "education_pricing_differences"
    t.text "onboarding_assistance"
    t.text "offboarding_assistance"
    t.string "deployment_model"
    t.string "addon_extension_type"
    t.text "addon_extension_details"
    t.string "api"
    t.text "api_capabilities"
    t.text "api_automation"
    t.text "government_network_type", default: [], array: true
    t.string "government_network_other"
    t.boolean "web_interface"
    t.text "web_interface_details"
    t.text "supported_browsers", default: [], array: true
    t.boolean "installed_application"
    t.text "supported_os", default: [], array: true
    t.text "supported_os_other"
    t.boolean "mobile_devices"
    t.text "mobile_desktop_differences"
    t.string "accessibility_type"
    t.text "accessibility_exclusions"
    t.string "scaling_type"
    t.text "guaranteed_availability"
    t.text "support_options", default: [], array: true
    t.text "support_options_additional_cost"
    t.text "support_levels"
    t.text "data_import_formats", default: [], array: true
    t.text "data_import_formats_other"
    t.text "data_export_formats", default: [], array: true
    t.text "data_export_formats_other"
    t.string "audit_storage_period"
    t.string "log_storage_period"
    t.string "data_location"
    t.text "data_location_other"
    t.boolean "data_location_control"
    t.boolean "third_party_involved"
    t.text "third_party_involved_details"
    t.string "backup_capability"
    t.string "backup_scheduling_type"
    t.string "backup_recovery_type"
    t.text "encryption_transit_user_types", default: [], array: true
    t.text "encryption_transit_user_other"
    t.text "encryption_transit_network_types", default: [], array: true
    t.text "encryption_transit_network_other"
    t.text "encryption_rest_types", default: [], array: true
    t.text "encryption_rest_other"
    t.boolean "authentication_required"
    t.text "authentication_types", default: [], array: true
    t.text "authentication_other"
    t.string "data_centre_security_standards"
    t.boolean "iso_27001"
    t.string "iso_27001_accreditor"
    t.date "iso_27001_date"
    t.text "iso_27001_exclusions"
    t.boolean "iso_27017"
    t.string "iso_27017_accreditor"
    t.date "iso_27017_date"
    t.text "iso_27017_exclusions"
    t.boolean "iso_27018"
    t.string "iso_27018_accreditor"
    t.date "iso_27018_date"
    t.text "iso_27018_exclusions"
    t.boolean "csa_star"
    t.string "csa_star_accreditor"
    t.date "csa_star_date"
    t.string "csa_star_level"
    t.text "csa_star_exclusions"
    t.boolean "pci_dss"
    t.string "pci_dss_accreditor"
    t.date "pci_dss_date"
    t.text "pci_dss_exclusions"
    t.boolean "soc_1"
    t.boolean "soc_2"
    t.string "secure_development_approach"
    t.string "penetration_testing_frequency"
    t.string "penetration_testing_approach"
    t.text "outage_channel_types", default: [], array: true
    t.text "outage_channel_other"
    t.text "metrics_contents"
    t.text "metrics_channel_types", default: [], array: true
    t.text "metrics_channel_other"
    t.text "usage_channel_types", default: [], array: true
    t.text "usage_channel_other"
    t.text "audiences_other"
    t.string "pricing_currency"
    t.string "pricing_currency_other"
    t.boolean "not_for_profit_pricing"
    t.text "not_for_profit_pricing_eligibility"
    t.text "not_for_profit_pricing_differences"
    t.text "deployment_model_other"
    t.text "data_location_unknown_reason"
    t.boolean "own_data_centre"
    t.text "own_data_centre_details"
    t.boolean "audit_information"
    t.boolean "data_access_restrictions"
    t.text "data_access_restrictions_details"
    t.string "encryption_keys_controller"
  end

  create_table "seller_accreditations", force: :cascade do |t|
    t.integer "seller_id", null: false
    t.string "accreditation"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "seller_addresses", force: :cascade do |t|
    t.integer "seller_id", null: false
    t.string "address"
    t.string "suburb"
    t.string "state"
    t.string "postcode"
    t.boolean "primary"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "seller_applications", force: :cascade do |t|
    t.string "state", null: false
    t.text "response"
    t.datetime "started_at"
    t.datetime "submitted_at"
    t.datetime "decided_at"
    t.integer "seller_id", null: false
    t.integer "assigned_to_id"
    t.boolean "tailor_complete", default: false
  end

  create_table "seller_awards", force: :cascade do |t|
    t.integer "seller_id", null: false
    t.string "award"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "seller_engagements", force: :cascade do |t|
    t.integer "seller_id", null: false
    t.string "engagement"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sellers", force: :cascade do |t|
    t.string "state", null: false
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "abn"
    t.text "summary"
    t.string "website_url"
    t.string "linkedin_url"
    t.string "number_of_employees"
    t.boolean "start_up"
    t.boolean "sme"
    t.boolean "not_for_profit"
    t.boolean "regional"
    t.boolean "travel"
    t.boolean "disability"
    t.boolean "female_owned"
    t.boolean "indigenous"
    t.boolean "no_experience"
    t.boolean "local_government_experience"
    t.boolean "state_government_experience"
    t.boolean "federal_government_experience"
    t.boolean "international_government_experience"
    t.string "contact_name"
    t.string "contact_email"
    t.string "contact_phone"
    t.string "representative_name"
    t.string "representative_email"
    t.string "representative_phone"
    t.boolean "investigations"
    t.boolean "legal_proceedings"
    t.boolean "insurance_claims"
    t.boolean "conflicts_of_interest"
    t.boolean "other_circumstances"
    t.text "investigations_details"
    t.text "legal_proceedings_details"
    t.text "insurance_claims_details"
    t.text "conflicts_of_interest_details"
    t.text "other_circumstances_details"
    t.text "tools"
    t.text "methodologies"
    t.text "technologies"
    t.text "services", default: [], array: true
    t.date "financial_statement_expiry"
    t.date "professional_indemnity_certificate_expiry"
    t.date "workers_compensation_certificate_expiry"
    t.boolean "agree"
    t.datetime "agreed_at"
    t.integer "agreed_by"
    t.boolean "australian_owned"
    t.boolean "rural_remote"
    t.boolean "workers_compensation_exempt"
    t.string "representative_position"
    t.date "product_liability_certificate_expiry"
    t.boolean "receivership"
    t.text "receivership_details"
    t.string "corporate_structure"
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "roles", default: [], array: true
    t.integer "seller_id"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "waiting_sellers", force: :cascade do |t|
    t.string "name", null: false
    t.string "abn", null: false
    t.string "address"
    t.string "suburb"
    t.string "postcode"
    t.string "state"
    t.string "country"
    t.string "contact_name"
    t.string "contact_email"
    t.string "contact_position"
    t.string "website_url"
    t.string "invitation_state", null: false
    t.string "invitation_token"
    t.datetime "invited_at"
    t.datetime "joined_at"
    t.integer "seller_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "seller_accreditations", "sellers"
  add_foreign_key "seller_applications", "sellers"
  add_foreign_key "seller_awards", "sellers"
  add_foreign_key "seller_engagements", "sellers"
end
