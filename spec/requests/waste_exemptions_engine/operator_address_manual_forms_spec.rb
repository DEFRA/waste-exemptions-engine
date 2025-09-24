# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Operator Address Manual Forms", :vcr do
    before { VCR.insert_cassette("postcode_valid") }
    after { VCR.eject_cassette }

    let(:form_data) do
      {
        operator_address: {
          premises: "Example House",
          street_address: "2 On The Road",
          locality: "Near Horizon House",
          city: "Bristol",
          postcode: "BS1 5AH"
        }
      }
    end

    it_behaves_like "GET form", :operator_address_manual_form, "/operator-address-manual"
    it_behaves_like "POST form", :operator_address_manual_form, "/operator-address-manual" do
      let(:form_data) do
        {
          operator_address: {
            premises: "Example House",
            street_address: "2 On The Road",
            locality: "Near Horizon House",
            city: "Bristol",
            postcode: "BS1 5AH"
          }
        }
      end
      let(:invalid_form_data) do
        [
          {
            operator_address: {
              premises: nil,
              street_address: nil,
              locality: nil,
              city: nil,
              postcode: nil
            }
          }
        ]
      end
    end

    context "when editing operator address on Check Your Answers page - new registration" do
      let(:operator_address_manual_form) { build(:check_your_answers_operator_address_manual_form) }
      let(:transient_registration) { create(:new_registration, workflow_state: "operator_address_manual_form") }

      it "redirects back to check-your-answers when submitted" do
        post "/waste_exemptions_engine/#{operator_address_manual_form.token}/operator-address-manual",
             params: { operator_address_manual_form: form_data }
        expect(response).to redirect_to(check_your_answers_forms_path(operator_address_manual_form.token))
      end
    end

    context "when editing operator address on Renewal Start page - renew registrations" do
      let(:renewal_start_operator_address_manual_form) { build(:renewal_start_operator_address_manual_form) }

      it "pre-fills the form with the operator address" do
        get "/waste_exemptions_engine/#{renewal_start_operator_address_manual_form.token}/operator-address-manual"
        expect(response.body).to include(renewal_start_operator_address_manual_form.postcode)
      end

      it "redirects back to renewal start form when submitted" do
        post "/waste_exemptions_engine/#{renewal_start_operator_address_manual_form.token}/operator-address-manual",
             params: { operator_address_manual_form: form_data }
        expect(response).to redirect_to(new_renewal_start_form_path(token: renewal_start_operator_address_manual_form.token))
      end
    end
  end
end
