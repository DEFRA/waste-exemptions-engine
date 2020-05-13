# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Confirm Edit Cancelled Forms", type: :request do
    before(:each) do
      WasteExemptionsEngine.configuration.edit_enabled = "true"
    end

    describe "GET confirm_edit_cancelled_form" do
      let(:form) { build(:confirm_edit_cancelled_form) }
      let(:request_path) { "/waste_exemptions_engine/#{form.token}/confirm-edit-cancelled" }

      it "renders the appropriate template, returns a 200 status code and W3C valid HTML content" do
        get request_path

        expect(response).to render_template("waste_exemptions_engine/confirm_edit_cancelled_forms/new")
        expect(response.code).to eq("200")
        expect(response.body).to have_valid_html
      end
    end

    empty_form_is_valid = true
    include_examples "go back", :confirm_edit_cancelled_form, "/confirm-edit-cancelled/back"
    include_examples "POST form", :confirm_edit_cancelled_form, "/confirm-edit-cancelled", empty_form_is_valid do
      let(:form_data) { {} }
      let(:invalid_form_data) { [] }
    end
  end
end
