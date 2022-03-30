# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe NewRegistration, type: :model do
    describe "#workflow_state" do
      let(:new_registration) do
        create(:new_registration,
               workflow_state: :check_contact_phone_form,
               temp_reuse_applicant_phone: temp_reuse_applicant_phone)
      end

      context "when temp_reuse_applicant_phone is true" do
        let(:temp_reuse_applicant_phone) { true }

        it "transitions to :contact_email_form" do
          expect(new_registration)
            .to transition_from(:check_contact_phone_form)
            .to(:contact_email_form)
            .on_event(:next)
        end
      end

      context "when temp_reuse_applicant_phone is false" do
        let(:temp_reuse_applicant_phone) { false }

        it "transitions to :contact_phone_form" do
          expect(new_registration)
            .to transition_from(:check_contact_phone_form)
            .to(:contact_phone_form)
            .on_event(:next)
        end
      end
    end
  end
end
