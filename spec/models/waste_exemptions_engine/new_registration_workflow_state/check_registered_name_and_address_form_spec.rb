# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe NewRegistration, type: :model do
    describe "#workflow_state" do
      let(:new_registration) do
        create(:new_registration,
               workflow_state: :check_registered_name_and_address_form,
               temp_use_registered_company_details: temp_use_registered_company_details)
      end

      context "when temp_use_registered_company_details is true" do
        let(:temp_use_registered_company_details) { true }

        it "transitions to :operator_postcode_form" do
          expect(new_registration)
            .to transition_from(:check_registered_name_and_address_form)
            .to(:operator_postcode_form)
            .on_event(:next)
        end
      end

      context "when temp_use_registered_company_details is false" do
        let(:temp_use_registered_company_details) { false }

        it "transitions to :incorrect_company" do
          expect(new_registration)
            .to transition_from(:check_registered_name_and_address_form)
            .to(:incorrect_company_form)
            .on_event(:next)
        end
      end
    end
  end
end
