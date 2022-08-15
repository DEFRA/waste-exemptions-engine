# frozen_string_literal: true

WasteExemptionsEngine.configure do |config|
  # General config
  config.application_name = "waste-exemptions-front-office"
  config.git_repository_url = "https://github.com/DEFRA/waste-exemptions-front-office"

  # Companies house API config
  config.companies_house_host = ENV["COMPANIES_HOUSE_URL"] || "https://api.companieshouse.gov.uk/company/"
  config.companies_house_api_key = ENV["COMPANIES_HOUSE_API_KEY"]

  # Address lookup config
  config.address_host = ENV["ADDRESSBASE_URL"] || "http://localhost:3002"

  # Email config
  config.email_service_email = ENV["EMAIL_SERVICE_EMAIL"] || "wex-local@example.com"

  # PDF config
  config.use_xvfb_for_wickedpdf = ENV["USE_XVFB_FOR_WICKEDPDF"] || "true"

  # Last Email Cache config
  config.use_last_email_cache = ENV["USE_LAST_EMAIL_CACHE"] || "false"

  # Renewing config
  config.renewal_window_before_expiry_in_days = ENV["RENEWAL_WINDOW_BEFORE_EXPIRY_IN_DAYS"] || 28
  config.renewal_window_after_expiry_in_days = ENV["RENEWAL_WINDOW_AFTER_EXPIRY_IN_DAYS"] || 30

  # Airbrake config
  config.airbrake_enabled = false
  config.airbrake_host = "http://localhost"
  config.airbrake_project_key = "abcde12345"
  config.airbrake_blocklist = [/password/i, /authorization/i]

  # Notify config
  config.notify_api_key = ENV["NOTIFY_API_KEY"]
end
WasteExemptionsEngine.start_airbrake
