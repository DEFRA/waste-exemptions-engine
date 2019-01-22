# frozen_string_literal: true

require "waste_exemptions_engine/engine"

module WasteExemptionsEngine

  # Configuration pattern based on
  # https://guides.rubyonrails.org/engines.html#configuring-an-engine

  # General config
  mattr_accessor :service_name do
    "Waste Exemptions Service"
  end
  mattr_accessor :application_name
  mattr_accessor :git_repository_url
  mattr_accessor :years_before_expiry do
    3
  end

  # Companies house API config
  mattr_accessor :companies_house_host do
    "https://api.companieshouse.gov.uk/company/"
  end
  mattr_accessor :companies_house_api_key

  # Addressbase config
  mattr_accessor :addressbase_url

  # Email config
  mattr_accessor :email_service_email

  # PDF config
  mattr_accessor :use_xvfb_for_wickedpdf do
    "true"
  end
end
