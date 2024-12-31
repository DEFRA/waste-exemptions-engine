# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "waste_exemptions_engine/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "waste_exemptions_engine"
  s.version     = WasteExemptionsEngine::VERSION
  s.authors     = ["Defra"]
  s.email       = ["alan.cruikshanks@environment-agency.gov.uk"]
  s.homepage    = "https://github.com/DEFRA/waste-exemptions-engine"
  s.summary     = "Rails engine for the Waste Exemptions service."
  s.description = "Rails engine for the Waste Exemptions service."
  s.license     = "The Open Government Licence (OGL) Version 3"

  s.metadata["rubygems_mfa_required"] = "true"

  s.files = Dir["{app,config,db,lib}/**/*", "LICENSE", "Rakefile", "README.md"]
  s.required_ruby_version = ">= 3.2"

  # Use AASM to manage states and transitions
  s.add_dependency "aasm", "~> 5.5"

  s.add_dependency "high_voltage", "~> 3.1"
  s.add_dependency "rails", "~> 7.1"

  # paper_trail currently does not support rails 7.2.
  s.add_dependency "activerecord", "< 7.2"

  # Use rest-client for external requests, eg. to Companies House
  s.add_dependency "rest-client", "~> 2.1"

  # sprockets-4.0.0 requires ruby version >= 2.5.0, which is incompatible with the current version, ruby 2.4.2p198
  s.add_dependency "sprockets"

  # Used to convert national grid references to easting and northing coordinates
  s.add_dependency "os_map_ref", "~> 0.5"

  # Used to handle requests to the address lookup web service used (currently
  # EA Address Facade v1)
  s.add_dependency "defra_ruby_address"

  # # defra_ruby_alert is a gem we created to manage airbrake across projects
  s.add_dependency "defra_ruby_alert"

  # Used to identify the EA area for a registration
  s.add_dependency "defra_ruby_area", "~> 2.2"

  # Used as part of testing. When enabled adds a /last-email route from which
  # details of the last email sent by the app can be accessed
  s.add_dependency "defra_ruby_email"

  # Use Notify to send emails and letters
  s.add_dependency "notifications-ruby-client"

  s.add_dependency "pg"

  # Used for auditing and version control
  s.add_dependency "paper_trail"

  # Validations
  # A defra created gem of shared validators
  s.add_dependency "defra_ruby_validators", "~> 3.0"

  # Use the companies house gem to access the Companies House API
  s.add_dependency "defra_ruby_companies_house"

  # Use to ensure phone numbers are in a valid and recognised format
  s.add_dependency "phonelib"

  # UK postcode parsing and validation for Ruby
  s.add_dependency "uk_postcode"

  # Use to validate e-mail addresses against RFC 2822 and RFC 3696
  s.add_dependency "validates_email_format_of"

  # Used to generate a PDF from HTML
  s.add_dependency "wicked_pdf"

  # Used to handle payments via Govpay API
  s.add_dependency "defra_ruby_govpay"
end
