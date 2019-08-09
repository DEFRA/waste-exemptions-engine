# frozen_string_literal: true

WasteExemptionsEngine.configure do |config|
  # General config
  config.application_name = "waste-exemptions-front-office"
  config.git_repository_url = "https://github.com/DEFRA/waste-exemptions-front-office"

  # Companies house API config
  config.companies_house_host = ENV["COMPANIES_HOUSE_URL"] || "https://api.companieshouse.gov.uk/company/"
  config.companies_house_api_key = ENV["COMPANIES_HOUSE_API_KEY"]

  # Addressbase facade config
  config.addressbase_url = ENV["ADDRESSBASE_URL"] || "http://localhost:9002"

  # Email config
  config.email_service_email = ENV["EMAIL_SERVICE_EMAIL"] || "wex-local@example.com"

  # PDF config
  config.use_xvfb_for_wickedpdf = ENV["USE_XVFB_FOR_WICKEDPDF"] || "true"

  # Last Email Cache config
  config.use_last_email_cache = ENV["USE_LAST_EMAIL_CACHE"] || "false"

  # Renewing config
  config.renewal_window_open_before_days = ENV["RENEWAL_WINDOW_OPEN_BEFORE_DAYS"] || 28
  config.registration_renewal_grace_window = ENV["REGISTRATION_RENEWAL_GRACE_WINDOW"] || 30
end
