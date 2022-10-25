# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe NewRegistration do
    describe "#workflow_state" do
      let(:new_registration) do
        create(:new_registration,
               workflow_state: :check_contact_phone_form,
               temp_reuse_applicant_phone: temp_reuse_applicant_phone,
               applicant_email: applicant_email)
      end
      let(:applicant_email) { nil }

      context "when temp_reuse_applicant_phone is true" do
        let(:temp_reuse_applicant_phone) { true }

        context "when applicant_email is present" do
          let(:applicant_email) { Faker::Internet.email }

          it "transitions to :check_contact_email_form" do
            expect(new_registration)
              .to transition_from(:check_contact_phone_form)
              .to(:check_contact_email_form)
              .on_event(:next)
          end
        end

        context "when applicant email is not present" do
          let(:applicant_email) { nil }

          it "transitions to :contact_email_form" do
            expect(new_registration)
              .to transition_from(:check_contact_phone_form)
              .to(:contact_email_form)
              .on_event(:next)
          end
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
