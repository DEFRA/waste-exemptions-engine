# frozen_string_literal: true

require "waste_exemptions_engine/engine"

module WasteExemptionsEngine

  # Enable the ability to configure the gem from its host app, rather than
  # reading directly from env vars. Derived from
  # https://robots.thoughtbot.com/mygem-configure-block
  class << self
    attr_writer :configuration

    def configuration
      @configuration ||= Configuration.new
    end
  end

  def self.configure
    yield(configuration)
  end

  class Configuration
    # General config
    attr_accessor :service_name, :application_name, :git_repository_url, :years_before_expiry
    # Companies house config
    attr_accessor :companies_house_host, :companies_house_api_key
    # Addressbase config
    attr_accessor :addressbase_url
    # Email config
    attr_accessor :email_service_email
    # PDF config
    attr_accessor :use_xvfb_for_wickedpdf

    def initialize
      @service_name = "Waste Exemptions Service"
      @years_before_expiry = 3
      @companies_house_host = "https://api.companieshouse.gov.uk/company/"
      @use_xvfb_for_wickedpdf = "true"
    end
  end
end
