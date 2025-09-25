# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Deregistration Complete Full Forms" do
    let(:registration) { create(:registration) }

    it_behaves_like "GET form", :deregistration_complete_full_form, "/deregistration-complete-full"
    it_behaves_like "unable to POST form", :deregistration_complete_full_form, "/deregistration-complete-full"

    context "when the form is loaded" do
      let!(:renewing_registration) { create(:renewing_registration, workflow_state: "deregistration_complete_full_form") }
      let(:token) { renewing_registration.token }

      it "deletes the transient_registration" do
        expect { get new_deregistration_complete_full_form_path(token) }
          .to change(RenewingRegistration, :count).by(-1)
      end
    end
  end
end
