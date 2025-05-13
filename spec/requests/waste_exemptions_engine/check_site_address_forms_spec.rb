# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Check Site Address Forms" do
    include_examples "GET form", :check_site_address_form, "/check-site-address"
    include_examples "POST form", :check_site_address_form, "/check-site-address" do
      let(:form_data) { { temp_reuse_address_for_site_location: "a_different_address" } }
      let(:invalid_form_data) { [{ temp_reuse_address_for_site_location: " " }] }
    end

    context "when editing site address on Check Your Answers page - new registration" do
      let(:check_site_address_form) { build(:check_your_answers_check_site_address_form) }
      let(:transient_registration) { create(:new_registration, workflow_state: "check_site_address_form") }

      context "when reusing the operator address" do
        let(:form_data) { { temp_reuse_address_for_site_location: "operator_address_option" } }

        it "redirects back to check-your-answers when submitted" do
          post "/waste_exemptions_engine/#{check_site_address_form.token}/check-site-address",
               params: { check_site_address_form: form_data }
          expect(response).to redirect_to(check_your_answers_forms_path(check_site_address_form.token))
        end
      end

      context "when selecting another address" do
        let(:form_data) { { temp_reuse_address_for_site_location: "a_different_address" } }

        it "redirects to the post code form when submitted" do
          post "/waste_exemptions_engine/#{check_site_address_form.token}/check-site-address",
               params: { check_site_address_form: form_data }
          expect(response).to redirect_to(site_postcode_forms_path(check_site_address_form.token))
        end
      end
    end
  end
end
