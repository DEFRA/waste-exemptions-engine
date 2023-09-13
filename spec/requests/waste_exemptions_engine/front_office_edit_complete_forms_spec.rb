# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Front Office Edit Complete Forms" do
    let(:form) { build(:front_office_edit_complete_form) }

    before { allow(RegistrationEditConfirmationEmailService).to receive(:run) }

    describe "GET front_office_edit_complete_form" do
      let(:request_path) { new_front_office_edit_complete_form_path(form.token) }

      it "renders the appropriate template, returns a 200 status code and W3C valid HTML content", :vcr do
        get request_path

        aggregate_failures do
          expect(response).to render_template("waste_exemptions_engine/front_office_edit_complete_forms/new")
          expect(response).to have_http_status(:ok)
          expect(response.body).to have_valid_html
        end
      end
    end

    describe "unable to go submit GET back" do
      let(:request_path) { "#{new_front_office_edit_complete_form_path(form.token)}/back" }

      it "raises an error" do
        expect { get request_path }.to raise_error(ActionController::RoutingError)
      end
    end

    include_examples "unable to POST form", :front_office_edit_complete_form, "/front-office-edit-complete"
  end
end
