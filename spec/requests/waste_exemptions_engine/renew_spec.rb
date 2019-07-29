# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Renew", type: :request do
    describe "GET start_form" do
      let(:registration) { build(:registration) }
      let(:request_path) { "/waste_exemptions_engine/renew/" }

      it "renders the appropriate template" do
        get request_path
        expect(response).to render_template("waste_exemptions_engine/renews/new")
      end

      it "creates a new RenewingRegistration" do
        expect { get request_path }.to change { RenewingRegistration.count }.by(1)
      end

      it "responds to the GET request with a 200 status code" do
        get request_path
        expect(response.code).to eq("200")
      end
    end
  end
end
