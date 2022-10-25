# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe NewRegistration do
    describe "#workflow_state" do
      let(:new_registration) do
        create(:new_registration,
               workflow_state: :check_contact_name_form,
               temp_reuse_applicant_name: temp_reuse_applicant_name)
      end

      context "when temp_reuse_applicant_name is true" do
        let(:temp_reuse_applicant_name) { true }

        it "transitions to :contact_position_form" do
          expect(new_registration)
            .to transition_from(:check_contact_name_form)
            .to(:contact_position_form)
            .on_event(:next)
        end
      end

      context "when temp_reuse_applicant_name is false" do
        let(:temp_reuse_applicant_name) { false }

        it "transitions to :contact_name_form" do
          expect(new_registration)
            .to transition_from(:check_contact_name_form)
            .to(:contact_name_form)
            .on_event(:next)
        end
      end
    end
  end
end
