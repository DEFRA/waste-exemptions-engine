# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe PagesController do
    it "includes HighVoltage::StaticPage" do
      included_modules = described_class.ancestors.select { |ancestor| ancestor.instance_of?(Module) }

      expect(included_modules)
        .to include(HighVoltage::StaticPage)
    end
  end
end
