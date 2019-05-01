# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Edit Cancelled Forms", type: :request do
    let(:form) { build(:edit_cancelled_form) }

    describe "GET edit_cancelled_form" do
      let(:request_path) { "/waste_exemptions_engine/edit-cancelled/#{form.token}" }

      it "renders the appropriate template" do
        get request_path
        expect(response).to render_template("waste_exemptions_engine/edit_cancelled_forms/new")
      end

      it "responds to the GET request with a 200 status code" do
        get request_path
        expect(response.code).to eq("200")
      end
    end

    describe "unable to go submit GET back" do
      let(:request_path) { "/waste_exemptions_engine/edit-cancelled/back/#{form.token}" }
      it "raises an error" do
        expect { get request_path }.to raise_error(ActionController::RoutingError)
      end
    end

    include_examples "unable to POST form", :edit_cancelled_form, "/edit-cancelled"
  end
end
