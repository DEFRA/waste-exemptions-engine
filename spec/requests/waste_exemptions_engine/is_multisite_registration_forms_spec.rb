# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Is Multisite Registration form" do
    before do
      allow(WasteExemptionsEngine::FeatureToggle).to receive(:active?).with(:enable_multisite).and_return(true)
    end

    it_behaves_like "GET form", :is_multisite_registration_form, "/is-multisite-registration", is_charged: true
    it_behaves_like "POST form", :is_multisite_registration_form, "/is-multisite-registration", is_charged: true do
      let(:form_data) { { is_multisite_registration: "true" } }
      let(:invalid_form_data) { [] }
    end

    context "when editing Is Multisite Registration on Check Your Answers page - new registration" do
      let(:is_multisite_registration_form) { build(:check_your_answers_edit_is_multisite_registration_form) }

      it "pre-fills is-multisite-registration information" do
        get "/waste_exemptions_engine/#{is_multisite_registration_form.token}/is-multisite-registration"

        expect(response.body).to have_tag("input", with: { type: "radio", name: "is_multisite_registration_form[is_multisite_registration]", checked: "checked", value: "true" })
      end

      it "redirects back to check-your-answers when submitted with false" do
        post "/waste_exemptions_engine/#{is_multisite_registration_form.token}/is-multisite-registration",
             params: { is_multisite_registration_form: { is_multisite_registration: false } }

        expect(response).to redirect_to(new_check_your_answers_form_path(is_multisite_registration_form.token))
      end

      it "does not redirect back to check-your-answers when submitted with true" do
        post "/waste_exemptions_engine/#{is_multisite_registration_form.token}/is-multisite-registration",
             params: { is_multisite_registration_form: { is_multisite_registration: true } }

        expect(response).not_to redirect_to(new_check_your_answers_form_path(is_multisite_registration_form.token))
      end

      it "redirects to the multisite site grid reference form when submitted with true" do
        post "/waste_exemptions_engine/#{is_multisite_registration_form.token}/is-multisite-registration",
             params: { is_multisite_registration_form: { is_multisite_registration: true } }

        expect(response).to redirect_to(new_multisite_site_grid_reference_form_path(is_multisite_registration_form.token))
      end
    end
  end
end
