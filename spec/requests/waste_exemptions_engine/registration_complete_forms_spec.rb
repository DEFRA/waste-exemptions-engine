# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Registration Complete Forms", type: :request do
    let(:form) { build(:registration_complete_form) }

    describe "GET registration_complete_form" do
      let(:request_path) { "/waste_exemptions_engine/registration-complete/#{form.token}" }

      it "renders the appropriate template" do
        get request_path
        expect(response).to render_template("waste_exemptions_engine/registration_complete_forms/new")
      end

      it "responds to the GET request with a 200 status code" do
        get request_path
        expect(response.code).to eq("200")
      end

      context "when the host application has a current_user" do
        let(:current_user) { OpenStruct.new(id: 1) }

        before do
          allow(WasteExemptionsEngine.configuration).to receive(:use_current_user_for_whodunnit).and_return(true)
          allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(current_user)
        end

        it "assigns the correct whodunnit to the registration version", versioning: true do
          get request_path
          registration = WasteExemptionsEngine::Registration.where(reference: form.transient_registration.reference).first
          expect(registration.reload.versions.last.whodunnit).to eq(current_user.id.to_s)
        end
      end

      context "when the host application does not have a current_user" do
        it "assigns the correct whodunnit to the registration version", versioning: true do
          get request_path
          registration = WasteExemptionsEngine::Registration.where(reference: form.transient_registration.reference).first
          expect(registration.reload.versions.last.whodunnit).to eq("public user")
        end
      end

      context "when an error happens during completion" do
        it "returns a 500 error for the user" do
          custom_error = StandardError.new("completion error")
          expect(Registration).to receive(:new).and_raise(custom_error)

          expect { get request_path }.to raise_error(custom_error)
        end
      end
    end

    describe "unable to go submit GET back" do
      let(:request_path) { "/waste_exemptions_engine/registration-complete/back/#{form.token}" }
      it "raises an error" do
        expect { get request_path }.to raise_error(ActionController::RoutingError)
      end
    end

    include_examples "unable to POST form", :registration_complete_form, "/egistration-complete"
  end
end
