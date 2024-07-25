# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe PaymentSummaryFormsController, type: :request do
    let(:form) { build(:payment_summary_form) }
    let(:request_path) { "/waste_exemptions_engine/#{form.token}/payment-summary" }

    it "is a FormController" do
      expect(described_class.superclass).to eq(WasteExemptionsEngine::FormsController)
    end

    describe "#new" do
      it "renders the correct template" do
        get request_path

        aggregate_failures do
          expect(response).to have_http_status(:ok)
          expect(response).to render_template("waste_exemptions_engine/payment_summary_forms/new")
        end
      end
    end

    describe "#create" do
      let(:valid_params) { {} }

      it "redirects to the correct workflow step" do
        post request_path, params: valid_params

        aggregate_failures do
          expect(response).to have_http_status(:see_other)
          expect(response).to redirect_to("/waste_exemptions_engine/#{form.token}/registration-complete")
        end
      end
    end
  end
end
