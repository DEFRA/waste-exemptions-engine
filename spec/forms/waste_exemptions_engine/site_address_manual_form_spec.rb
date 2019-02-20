# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe SiteAddressManualForm, type: :model do
    it_behaves_like "a manual address form", :site_address_manual_form

    it "includes SiteAddressForm" do
      included_modules = described_class.ancestors.select { |ancestor| ancestor.instance_of?(Module) }

      expect(included_modules)
        .to include(WasteExemptionsEngine::SiteAddressForm)
    end
  end
end
