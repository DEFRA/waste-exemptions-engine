# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe RenewNoExemptionsFormsController, type: :request do
    it "is a FormController" do
      expect(described_class.superclass).to eq(WasteExemptionsEngine::FormsController)
    end

    describe "#new" do
      let(:form) { build(:renew_no_exemptions_form) }
      let(:request_path) { "/waste_exemptions_engine/#{form.token}/renew-no-exemptions" }

      it "renders the correct template" do
        get request_path

        aggregate_failures do
          expect(response).to have_http_status(:ok)
          expect(response).to render_template("waste_exemptions_engine/renew_no_exemptions_forms/new")
        end
      end
    end
  end
end
