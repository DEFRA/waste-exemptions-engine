# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Contact Address Lookup Forms", :vcr do
    before { VCR.insert_cassette("postcode_valid", allow_playback_repeats: true) }
    after { VCR.eject_cassette }

    it_behaves_like "GET form", :contact_address_lookup_form, "/contact-address-lookup"
    it_behaves_like "POST form", :contact_address_lookup_form, "/contact-address-lookup" do
      let(:form_data) { { contact_address: { uprn: "340116" } } }
      let(:invalid_form_data) { [{ contact_address: { uprn: nil } }] }
    end

    it_behaves_like "skip to manual address",
                    :contact_address_lookup_form,
                    address_type: :contact

    context "when editing contact address on Check Your Answers page - new registration" do
      let(:contact_address_lookup_form) { build(:check_your_answers_contact_address_lookup_form) }
      let(:transient_registration) { create(:new_registration, workflow_state: "contact_address_lookup_form") }

      it "redirects back to check-your-answers when submitted" do
        post "/waste_exemptions_engine/#{contact_address_lookup_form.token}/contact-address-lookup",
             params: { contact_address_lookup_form: form_data }
        expect(response).to redirect_to(check_your_answers_forms_path(contact_address_lookup_form.token))
      end
    end

    context "when editing contact address on Renewal Start page - renew registrations" do
      let(:renewal_start_contact_address_lookup_form) { build(:renewal_start_contact_address_lookup_form) }

      it "pre-fills the form with the contact address" do
        get "/waste_exemptions_engine/#{renewal_start_contact_address_lookup_form.token}/contact-address-lookup"
        expect(response.body).to include(renewal_start_contact_address_lookup_form.postcode)
      end

      it "redirects back to renewal start form when submitted" do
        post "/waste_exemptions_engine/#{renewal_start_contact_address_lookup_form.token}/contact-address-lookup",
             params: { contact_address_lookup_form: form_data }
        expect(response).to redirect_to(new_renewal_start_form_path(token: renewal_start_contact_address_lookup_form.token))
      end
    end
  end
end
