# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe OperatorAddressLookupForm, type: :model do
    it_behaves_like "an address lookup form", :operator_address_lookup_form

    it "includes OperatorAddressForm" do
      included_modules = described_class.ancestors.select { |ancestor| ancestor.instance_of?(Module) }

      expect(included_modules)
        .to include(WasteExemptionsEngine::OperatorAddressForm)
    end
  end
end
