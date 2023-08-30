# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe FrontOfficeEditRegistration do
    describe "#workflow_state" do
      let(:current_state) { "edit_exemptions_form" }

      context "when no changes have been made" do
        subject(:edit_registration) { create(:front_office_edit_registration, workflow_state: current_state) }

        it { expect(edit_registration).to transition_from(current_state).to("front_office_edit_form").on_event(:next) }
      end

      context "when an exemption has been removed" do
        subject(:edit_registration) { create(:front_office_edit_registration, :modified, workflow_state: current_state) }

        before { edit_registration.excluded_exemptions << edit_registration.registration_exemptions.first }

        it { expect(edit_registration).to transition_from(current_state).to("confirm_edit_exemptions_form").on_event(:next) }
      end
    end
  end
end
