# frozen_string_literal: true

require "aasm"
require "has_secure_token"
require "high_voltage"
require "paper_trail"
require "defra_ruby_validators"
require "defra_ruby/address"
require "defra_ruby/alert"
require "defra_ruby/area"
require "wicked_pdf"

module WasteExemptionsEngine
  class Engine < ::Rails::Engine
    isolate_namespace WasteExemptionsEngine

    config.generators do |g|
      g.test_framework :rspec
      g.fixture_replacement :factory_bot
      g.factory_bot dir: "spec/factories"
    end

    config.autoload_paths << "#{config.root}/lib/waste_exemptions_engine/exceptions"
    config.autoload_paths << "#{config.root}/app/validators/concerns"
    config.autoload_paths << "#{config.root}/app/forms/concerns"

    # Load I18n translation files from engine before loading ones from the host app
    # This means values in the host app can override those in the engine
    config.before_initialize do
      engine_locales = Dir["#{config.root}/config/locales/**/*.yml"]
      config.i18n.load_path = engine_locales + config.i18n.load_path
    end

    initializer :append_migrations do |app|
      unless app.root.to_s.match?(root.to_s)
        config.paths["db/migrate"].expanded.each do |expanded_path|
          # Run the engine migrations before the host app migrations
          app.config.paths["db/migrate"].unshift(expanded_path)
        end
      end
    end
  end
end
