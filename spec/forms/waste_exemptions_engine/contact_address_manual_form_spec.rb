# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe ContactAddressManualForm, type: :model do
    it_behaves_like "a manual address form", :contact_address_manual_form

    it "includes ContactAddressForm" do
      included_modules = described_class.ancestors.select { |ancestor| ancestor.instance_of?(Module) }

      expect(included_modules)
        .to include(WasteExemptionsEngine::ContactAddressForm)
    end
  end
end
