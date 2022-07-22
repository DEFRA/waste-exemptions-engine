require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "dotenv/load"
require 'rails/all'
require 'active_record/connection_adapters/postgresql_adapter'
# require "sprockets/railtie"
# require "rails/test_unit/railtie"

Bundler.require(*Rails.groups)
require "waste_exemptions_engine"

module Dummy
  class Application < Rails::Application
    config.load_defaults 6.0
    config.autoloader = :classic
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    # config.active_record.raise_in_transactional_callbacks = true

    # Companies House config
    config.companies_house_host = ENV["COMPANIES_HOUSE_URL"] || "https://api.companieshouse.gov.uk/company/"
    config.companies_house_api_key = ENV["COMPANIES_HOUSE_API_KEY"]

    # https://edgeguides.rubyonrails.org/upgrading_ruby_on_rails.html#active-record-belongs-to-required-by-default-option
    config.active_record.belongs_to_required_by_default = false

    # https://edgeguides.rubyonrails.org/upgrading_ruby_on_rails.html#expiry-in-signed-or-encrypted-cookie-is-now-embedded-in-the-cookies-values
    # config.action_dispatch.use_authenticated_cookie_encryption = false

    # Change automatic expire of renew's magic link token
    config.registration_renewal_grace_window = ENV["REGISTRATION_RENEWAL_GRACE_WINDOW"] || 30
    config.first_renewal_email_reminder_days = ENV["FIRST_RENEWAL_EMAIL_REMINDER_DAYS"]
    config.i18n.load_path += Dir["#{config.root}/config/locales/**/*.yml"]
  end
end
