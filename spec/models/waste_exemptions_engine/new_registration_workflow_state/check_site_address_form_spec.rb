# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe NewRegistration, type: :model do
    describe "#workflow_state" do
      let(:new_registration) do
        create(:new_registration,
               workflow_state: :check_site_address_form,
               temp_reuse_address_for_site_location: temp_reuse_address_for_site_location)
      end

      context "when temp_reuse_address_for_site_location is true for the operators address" do
        let(:temp_reuse_address_for_site_location) { "operator_address_option" }

        it "transitions to :check_your_answers_form" do
          expect(new_registration)
            .to transition_from(:check_site_address_form)
            .to(:check_your_answers_form)
            .on_event(:next)
        end
      end

      context "when temp_reuse_address_for_site_location is a different_address_option" do
        let(:temp_reuse_address_for_site_location) { "a_different_address" }

        it "transitions to :site_postcode_form" do
          expect(new_registration)
            .to transition_from(:check_site_address_form)
            .to(:site_postcode_form)
            .on_event(:next)
        end
      end
    end
  end
end
