# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Renewal Start Forms" do
    let(:form) { build(:renewal_start_form) }

    describe "GET renewal_start_form" do
      let(:request_path) { "/waste_exemptions_engine/#{form.token}/renewal-start" }

      it "renders the appropriate template", :vcr do
        get request_path

        expect(response).to render_template("waste_exemptions_engine/renewal_start_forms/new")
      end

      it "returns a 200 status code", :vcr do
        get request_path

        expect(response).to have_http_status(:ok)
      end

      it "returns W3C valid HTML content", :vcr, :ignore_hidden_autocomplete do
        get request_path

        expect(response.body).to have_valid_html
      end
    end

    describe "unable to go submit GET back" do
      let(:request_path) { "/waste_exemptions_engine/#{form.token}/renewal-complete/back" }

      it "raises an error" do
        expect { get request_path }.to raise_error(ActionController::RoutingError)
      end
    end

    include_examples "POST form", :renewal_start_form, "/renewal-start" do
      let(:form_data) { { temp_renew_without_changes: "true" } }
      let(:invalid_form_data) { [] }
    end

    RSpec.shared_examples "a valid transition" do |request_path, redirects_to|
      let(:form) { build(:renewal_start_form) }

      it "redirects to valid form page" do
        get send(request_path, token: form.token)

        expect(response).to redirect_to send(redirects_to, token: form.token)
      end

      it "sets temp_check_your_answers_flow variable to true" do
        get send(request_path, token: form.token)

        expect(form.transient_registration.reload.temp_check_your_answers_flow).to be_truthy
      end

      it "adds renewal_start_form into the workflow history" do
        get send(request_path, token: form.token)

        expect(form.transient_registration.reload.workflow_history.last).to eq("renewal_start_form")
      end
    end

    context "when editing data on Check Your Answers" do
      describe "GET /renewal-start/exemptions" do
        it_behaves_like "a valid transition", :exemptions_renewal_start_forms_path, :new_exemptions_form_path
      end
    end
  end
end
