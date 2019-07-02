# frozen_string_literal: true

require "yaml"

module WasteExemptionsEngine
  class FeatureToggle
    def self.active?(feature_name)
      feature_toggles[feature_name] && feature_toggles[feature_name][:active]
    end

    class << self
      private

      # rubocop:disable Style/ClassVars
      def feature_toggles
        @@feature_toggles ||= load_feature_toggles
      end
      # rubocop:enable Style/ClassVars

      def load_feature_toggles
        HashWithIndifferentAccess.new(YAML.load_file(file_path))
      end

      def file_path
        Rails.root.join("config/feature_toggles.yaml")
      end
    end
  end
end
