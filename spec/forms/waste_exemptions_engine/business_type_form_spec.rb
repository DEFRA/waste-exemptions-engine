# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe BusinessTypeForm, type: :model do
    subject(:form) { build(:business_type_form) }

    BUSINESS_TYPES = %w[charity
                        limitedCompany
                        limitedLiabilityPartnership
                        localAuthority
                        partnership
                        soleTrader].freeze

    it "validates the business type using the BusinessTypeValidator class" do
      validators = form._validators
      expect(validators.keys).to include(:business_type)
      expect(validators[:business_type].first.class)
        .to eq(WasteExemptionsEngine::BusinessTypeValidator)
    end

    it_behaves_like "a validated form", :business_type_form do
      let(:valid_params) { { token: form.token, business_type: BUSINESS_TYPES.sample } }
      let(:invalid_params) do
        [
          { token: form.token, business_type: "foo" },
          { token: form.token, business_type: "" }
        ]
      end
    end

    describe "#submit" do
      context "when the form is valid" do
        it "updates the transient registration with the selected business type" do
          business_type = BUSINESS_TYPES.sample
          valid_params = { token: form.token, business_type: business_type }
          transient_registration = form.transient_registration

          expect(transient_registration.business_type).to be_blank
          form.submit(valid_params)
          expect(transient_registration.business_type).to eq(business_type)
        end
      end
    end
  end
end
