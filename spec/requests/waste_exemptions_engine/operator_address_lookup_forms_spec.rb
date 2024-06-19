# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Operator Address Lookup Forms", :vcr do
    before { VCR.insert_cassette("postcode_valid", allow_playback_repeats: true) }
    after { VCR.eject_cassette }

    include_examples "GET form", :operator_address_lookup_form, "/operator-address-lookup"
    include_examples "POST form", :operator_address_lookup_form, "/operator-address-lookup" do
      let(:form_data) { { operator_address: { uprn: "340116" } } }
      let(:invalid_form_data) { [{ operator_address: { uprn: nil } }] }
    end

    include_examples "skip to manual address",
                     :operator_address_lookup_form,
                     address_type: :operator

    context "when editing operator address on Check Your Answers page - new registration" do
      let(:operator_address_lookup_form) { build(:check_your_answers_operator_address_lookup_form) }
      let(:transient_registration) { create(:new_registration, workflow_state: "operator_address_lookup_form") }

      it "redirects back to check-your-answers when submitted" do
        post "/waste_exemptions_engine/#{operator_address_lookup_form.token}/operator-address-lookup",
             params: { operator_address_lookup_form: form_data }
        expect(response).to redirect_to(check_your_answers_forms_path(operator_address_lookup_form.token))
      end
    end
  end
end
