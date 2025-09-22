# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Confirm Edit Cancelled Forms" do
    before do
      WasteExemptionsEngine.configuration.edit_enabled = "true"
    end

    describe "GET confirm_back_office_edit_cancelled_form" do
      let(:form) { build(:confirm_back_office_edit_cancelled_form) }
      let(:request_path) { "/waste_exemptions_engine/#{form.token}/confirm-edit-cancelled" }

      it "renders the appropriate template" do
        get request_path

        expect(response).to render_template("waste_exemptions_engine/confirm_back_office_edit_cancelled_forms/new")
      end

      it "returns a 200 status code" do
        get request_path

        expect(response).to have_http_status(:ok)
      end

      it "returns W3C valid HTML content" do
        get request_path

        expect(response.body).to have_valid_html
      end
    end

    empty_form_is_valid = true
    it_behaves_like "POST form", :confirm_back_office_edit_cancelled_form, "/confirm-edit-cancelled", empty_form_is_valid do
      let(:form_data) { {} }
      let(:invalid_form_data) { [] }
    end
  end
end
