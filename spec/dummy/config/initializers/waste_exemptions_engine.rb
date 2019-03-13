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

  # PaperTrail config
  config.use_current_user_for_whodunnit = false
end
