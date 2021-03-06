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

  s.files = Dir["{app,config,db,lib}/**/*", "LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["spec/**/*"]

  # Use AASM to manage states and transitions
  s.add_dependency "aasm", "~> 4.12"

  s.add_dependency "has_secure_token"
  s.add_dependency "high_voltage", "~> 3.1"
  s.add_dependency "rails", "~> 6.0.3.1"

  # Use rest-client for external requests, eg. to Companies House
  s.add_dependency "rest-client", "~> 2.0"

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
  s.add_dependency "defra_ruby_area"

  # Used as part of testing. When enabled adds a /last-email route from which
  # details of the last email sent by the app can be accessed
  s.add_dependency "defra_ruby_email"

  # Use Notify to send emails and letters
  s.add_dependency "notifications-ruby-client"

  s.add_dependency "pg"

  s.add_development_dependency "rails-controller-testing"

  # Used for auditing and version control
  s.add_dependency "paper_trail", "~> 10.2.0"

  # Validations
  # A defra created gem of shared validators
  s.add_dependency "defra_ruby_validators"
  # Use to ensure phone numbers are in a valid and recognised format
  s.add_dependency "phonelib"
  # UK postcode parsing and validation for Ruby
  s.add_dependency "uk_postcode"
  # Use to validate e-mail addresses against RFC 2822 and RFC 3696
  s.add_dependency "validates_email_format_of"
  # Used to generate a PDF from HTML
  s.add_dependency "wicked_pdf"

  # Allows us to automatically generate the change log from the tags, issues,
  # labels and pull requests on GitHub. Added as a dependency so all dev's have
  # access to it to generate a log, and so they are using the same version.
  # New dev's should first create GitHub personal app token and add it to their
  # ~/.bash_profile (or equivalent)
  # https://github.com/skywinder/github-changelog-generator#github-token
  s.add_development_dependency "github_changelog_generator"

  s.add_development_dependency "bullet"
  s.add_development_dependency "database_cleaner"
  s.add_development_dependency "defra_ruby_style"
  s.add_development_dependency "dotenv-rails"
  s.add_development_dependency "factory_bot_rails"
  s.add_development_dependency "faker"
  s.add_development_dependency "parallel_tests"
  s.add_development_dependency "pdf-reader"
  s.add_development_dependency "pry-byebug"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "simplecov", "~> 0.17.1"
  s.add_development_dependency "timecop"
  s.add_development_dependency "vcr"
  s.add_development_dependency "w3c_validators"
  s.add_development_dependency "webmock"
end
