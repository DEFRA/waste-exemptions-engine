# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Transient Registration", type: :request do
    describe "GET go_back_forms_path" do
      context "when a valid transient registration exists" do
        let(:tier) { WasteCarriersEngine::Registration::UPPER_TIER }
        let(:workflow_state) { "register_in_wales_form" }
        let(:workflow_history) { %w[some_form location_form] }
        let(:transient_registration) do
          create(:new_registration,
                 workflow_state: workflow_state,
                 workflow_history: workflow_history)
        end

        it "returns a 302 response" do
          get go_back_forms_path(transient_registration[:token])

          expect(response).to have_http_status(303)
        end

        it "redirects to the previous form in the workflow_history" do
          get go_back_forms_path(transient_registration[:token])

          expect(response).to redirect_to(new_location_form_path(transient_registration[:token]))
        end

        context "when the transient registration has a partially invalid workflow history" do
          let(:workflow_history) { %w[location_form not_a_valid_state] }

          it "redirects to the form for the most recent valid state" do
            get go_back_forms_path(transient_registration[:token])

            expect(response).to redirect_to(new_location_form_path(transient_registration[:token]))
          end
        end

        context "when the transient registration has a fully invalid workflow history" do
          let(:workflow_history) do
            [
              "",
              "not_a_valid_state"
            ]
          end

          it "redirects to the default form" do
            get go_back_forms_path(transient_registration[:token])

            expect(response).to redirect_to(new_start_form_path(token: transient_registration[:token]))
          end
        end

        context "when the transient registration has no workflow history" do
          let(:workflow_history) { [] }

          it "redirects to the default form" do
            get go_back_forms_path(transient_registration[:token])

            expect(response).to redirect_to(new_start_form_path(token: transient_registration[:token]))
          end
        end
      end
    end
  end
end
