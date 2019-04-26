# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Edit Confirm Cancel Forms", type: :request do
    describe "GET edit_confirm_cancel_form" do
      let(:form) { build(:edit_confirm_cancel_form) }
      let(:good_request_path) { "/waste_exemptions_engine/edit-confirm-cancel/#{form.token}" }

      it "renders the appropriate template" do
        get good_request_path
        expect(response).to render_template("waste_exemptions_engine/edit_confirm_cancel_forms/new")
      end

      it "responds to the GET request with a 200 status code" do
        get good_request_path
        expect(response.code).to eq("200")
      end
    end

    empty_form_is_valid = true
    include_examples "go back", :edit_confirm_cancel_form, "/edit-confirm-cancel/back"
    include_examples "POST form", :edit_confirm_cancel_form, "/edit-confirm-cancel", empty_form_is_valid do
      let(:form_data) { {} }
    end
  end
end
