# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe NewRegistration do
    describe "#workflow_state" do
      let(:new_registration) do
        create(:new_registration,
               workflow_state: :check_contact_email_form,
               temp_reuse_applicant_email: temp_reuse_applicant_email)
      end

      context "when temp_reuse_applicant_email is true" do
        let(:temp_reuse_applicant_email) { "true" }

        it "transitions to :check_contact_address_form" do
          expect(new_registration)
            .to transition_from(:check_contact_email_form)
            .to(:check_contact_address_form)
            .on_event(:next)
        end
      end

      context "when temp_reuse_applicant_email is false" do
        let(:temp_reuse_applicant_email) { "false" }

        it "transitions to :contact_email_form" do
          expect(new_registration)
            .to transition_from(:check_contact_email_form)
            .to(:contact_email_form)
            .on_event(:next)
        end
      end
    end
  end
end
