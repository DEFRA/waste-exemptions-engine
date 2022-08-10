# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Business Type Forms", type: :request do
    include_examples "GET form", :business_type_form, "/business-type"
    include_examples "POST form", :business_type_form, "/business-type" do
      let(:form_data) { { business_type: "limitedCompany" } }
      let(:invalid_form_data) { [{ business_type: nil }] }
    end

    context "when renewing an existing registration" do
      let(:renew_business_type_form) { build(:renew_business_type_form) }
      let(:renewing_registration) { renew_business_type_form.transient_registration }
      let(:params) do
        { business_type_form: { business_type: "soleTrader" } }
      end

      it "does not change the business type" do
        expect { post "/waste_exemptions_engine/#{renew_business_type_form.token}/business-type", params: params }.not_to change {
          renewing_registration.business_type
        }
      end
    end
  end
end
