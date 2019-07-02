# frozen_string_literal: true

require "yaml"

module WasteExemptionsEngine
  class FeatureToggle
    def self.active?(feature_name)
      feature_toggles[feature_name] && feature_toggles[feature_name][:active]
    end

    private

    def self.feature_toggles
      @@feature_toggles ||= load_feature_toggles
    end

    def self.load_feature_toggles
      HashWithIndifferentAccess.new(YAML.load_file(file_path))
    end

    def self.file_path
      Rails.root.join("config/feature_toggles.yaml")
    end
  end
end
