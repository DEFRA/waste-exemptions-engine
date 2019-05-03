# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Confirm Edit Cancelled Forms", type: :request do
    before(:each) do
      WasteExemptionsEngine.configuration.edit_enabled = "true"
    end

    describe "GET confirm_edit_cancelled_form" do
      let(:form) { build(:confirm_edit_cancelled_form) }
      let(:good_request_path) { "/waste_exemptions_engine/confirm-edit-cancelled/#{form.token}" }

      it "renders the appropriate template" do
        get good_request_path
        expect(response).to render_template("waste_exemptions_engine/confirm_edit_cancelled_forms/new")
      end

      it "responds to the GET request with a 200 status code" do
        get good_request_path
        expect(response.code).to eq("200")
      end
    end

    empty_form_is_valid = true
    include_examples "go back", :confirm_edit_cancelled_form, "/confirm-edit-cancelled/back"
    include_examples "POST form", :confirm_edit_cancelled_form, "/confirm-edit-cancelled", empty_form_is_valid do
      let(:form_data) { {} }
    end
  end
end
