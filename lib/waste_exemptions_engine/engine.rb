# frozen_string_literal: true

module WasteExemptionsEngine
  class Engine < ::Rails::Engine
    isolate_namespace WasteExemptionsEngine

    config.generators do |g|
      g.test_framework :rspec
      g.fixture_replacement :factory_bot
      g.factory_bot dir: "spec/factories"
    end
  end
end
