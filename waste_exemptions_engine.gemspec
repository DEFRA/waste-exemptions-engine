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

  s.add_dependency "rails", "4.2.11"

  s.add_dependency "pg", "~> 0.18.4"

  # Allows us to automatically generate the change log from the tags, issues,
  # labels and pull requests on GitHub. Added as a dependency so all dev's have
  # access to it to generate a log, and so they are using the same version.
  # New dev's should first create GitHub personal app token and add it to their
  # ~/.bash_profile (or equivalent)
  # https://github.com/skywinder/github-changelog-generator#github-token
  s.add_development_dependency "github_changelog_generator"

  s.add_development_dependency "byebug"
  s.add_development_dependency "factory_bot_rails"
  s.add_development_dependency "rspec-rails", "~> 3.8.0"
end
