# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Contact Address Manual Forms", :vcr do
    before { VCR.insert_cassette("postcode_valid") }
    after { VCR.eject_cassette }

    include_examples "GET form", :contact_address_manual_form, "/contact-address-manual"
    include_examples "POST form", :contact_address_manual_form, "/contact-address-manual" do
      let(:form_data) do
        {
          contact_address: {
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
            contact_address: {
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

    context "when editing contact address on Check Your Answers page - new registration" do
      let(:contact_address_manual_form) { build(:check_your_answers_contact_address_manual_form) }
      let(:transient_registration) { create(:new_registration, workflow_state: "contact_address_manual_form") }

      it "redirects back to check-your-answers when submitted" do
        post "/waste_exemptions_engine/#{contact_address_manual_form.token}/contact-address-manual",
             params: { contact_address_manual_form: form_data }
        expect(response).to redirect_to(check_your_answers_forms_path(contact_address_manual_form.token))
      end
    end
  end
end
