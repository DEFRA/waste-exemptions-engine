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

  # Use Airbrake for error reporting to Errbit
  # Version 6 and above cause errors with Errbit, so use 5.8.1 for now
  s.add_dependency "airbrake", "5.8.1"
  s.add_dependency "has_secure_token"
  s.add_dependency "high_voltage", "~> 3.1"
  s.add_dependency "rails", "~> 4.2.11"
  # Use rest-client for external requests, eg. to Companies House
  s.add_dependency "rest-client", "~> 2.0"

  # Used to convert national grid references to easting and northing coordinates
  s.add_dependency "os_map_ref", "~> 0.5"

  # Used to identify the EA area for a registration
  s.add_dependency "defra_ruby_area"

  s.add_dependency "pg", "~> 0.18.4"

  # Used for auditing and version control
  s.add_dependency "paper_trail", "~> 10.2.0"

  # Validations
  # A defra created gem of shared validators
  s.add_dependency "defra_ruby_validators", "~> 2.1.2"
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
  s.add_development_dependency "rspec-rails", "~> 3.8.0"
  s.add_development_dependency "simplecov"
  s.add_development_dependency "timecop"
  s.add_development_dependency "vcr"
  s.add_development_dependency "w3c_validators"
  s.add_development_dependency "webmock"
end
