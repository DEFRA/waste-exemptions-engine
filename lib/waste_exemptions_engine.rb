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
    attr_accessor :service_name, :application_name, :git_repository_url, :years_before_expiry, :default_assistance_mode
    # Addressbase config
    attr_accessor :addressbase_url
    # Email config
    attr_accessor :email_service_email
    # PDF config
    attr_writer :use_xvfb_for_wickedpdf
    # Last Email chaching and retrieval functionality
    attr_writer :use_last_email_cache
    # PaperTrail config
    attr_accessor :use_current_user_for_whodunnit

    # Companies house API config
    attr_reader :companies_house_host, :companies_house_api_key

    def initialize
      @service_name = "Waste Exemptions Service"
      @years_before_expiry = 3
      @use_xvfb_for_wickedpdf = true
      @use_last_email_cache = false
    end

    def use_xvfb_for_wickedpdf
      change_string_to_boolean_for(@use_xvfb_for_wickedpdf)
    end

    def use_last_email_cache
      change_string_to_boolean_for(@use_last_email_cache)
    end

    def companies_house_host=(value)
      DefraRubyValidators.configure do |configuration|
        configuration.companies_house_host = value
      end
    end

    def companies_house_api_key=(value)
      DefraRubyValidators.configure do |configuration|
        configuration.companies_house_api_key = value
      end
    end

    # If the setting's value is "true", then set to a boolean true. Otherwise, set it to false.
    def change_string_to_boolean_for(setting)
      setting = setting == "true" if setting.is_a?(String)
      setting
    end
  end
end
