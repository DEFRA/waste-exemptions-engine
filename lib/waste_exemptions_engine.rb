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

  def self.start_airbrake
    DefraRuby::Alert.start
  end

  class Configuration
    # General config
    attr_accessor :service_name, :application_name, :git_repository_url, :years_before_expiry, :default_assistance_mode
    # Edit config
    attr_writer :edit_enabled
    # Email config
    attr_accessor :email_service_email
    # PDF config
    attr_writer :use_xvfb_for_wickedpdf
    # PaperTrail config
    attr_accessor :use_current_user_for_whodunnit
    # Renewing
    attr_accessor :renewal_window_before_expiry_in_days, :renewal_window_after_expiry_in_days

    # Address lookup config
    attr_reader :address_host

    # Companies house API config
    attr_reader :companies_house_host, :companies_house_api_key

    def initialize
      @service_name = "Waste Exemptions Service"
      @years_before_expiry = 3
      @edit_enabled = false
      @use_xvfb_for_wickedpdf = true
      @use_last_email_cache = false

      configure_airbrake_rails_properties
    end

    def edit_enabled
      change_string_to_boolean_for(@edit_enabled)
    end

    def use_xvfb_for_wickedpdf
      change_string_to_boolean_for(@use_xvfb_for_wickedpdf)
    end

    def use_last_email_cache
      change_string_to_boolean_for(@use_last_email_cache)
    end

    def address_host=(value)
      @address_host = value
      DefraRuby::Address.configure do |configuration|
        configuration.host = value
      end
    end

    def companies_house_host=(value)
      DefraRuby::Validators.configure do |configuration|
        configuration.companies_house_host = value
      end
    end

    def companies_house_api_key=(value)
      DefraRuby::Validators.configure do |configuration|
        configuration.companies_house_api_key = value
      end
    end

    # Airbrake configuration properties (viia defra_ruby_alert gem)
    def airbrake_enabled=(value)
      DefraRuby::Alert.configure do |configuration|
        configuration.enabled = change_string_to_boolean_for(value)
      end
    end

    def airbrake_host=(value)
      DefraRuby::Alert.configure do |configuration|
        configuration.host = value
      end
    end

    def airbrake_project_key=(value)
      DefraRuby::Alert.configure do |configuration|
        configuration.project_key = value
      end
    end

    def airbrake_blacklist=(value)
      DefraRuby::Alert.configure do |configuration|
        configuration.blacklist = value
      end
    end

    # Last Email caching and retrieval functionality
    def use_last_email_cache=(value)
      DefraRuby::Email.configure do |configuration|
        configuration.enabled = change_string_to_boolean_for(value)
      end
    end

    private

    # If the setting's value is "true", then set to a boolean true. Otherwise, set it to false.
    def change_string_to_boolean_for(setting)
      setting = setting == "true" if setting.is_a?(String)
      setting
    end

    def configure_airbrake_rails_properties
      DefraRuby::Alert.configure do |configuration|
        configuration.root_directory = Rails.root
        configuration.logger = Rails.logger
        configuration.environment = Rails.env
      end
    end
  end
end
