# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe SiteAddressLookupForm, type: :model do
    it_behaves_like "an address lookup form", :site_address_lookup_form

    it "includes SiteAddressForm" do
      included_modules = described_class.ancestors.select { |ancestor| ancestor.instance_of?(Module) }

      expect(included_modules)
        .to include(WasteExemptionsEngine::SiteAddressForm)
    end
  end
end
