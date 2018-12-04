# frozen_string_literal: true

module WasteExemptionsEngine
  class Engine < ::Rails::Engine
    isolate_namespace WasteExemptionsEngine

    config.generators do |g|
      g.test_framework :rspec
    end
  end
end
