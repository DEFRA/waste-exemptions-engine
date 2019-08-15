# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Operator Name Forms", type: :request do
    include_examples "GET form", :operator_name_form, "/operator-name"
    include_examples "go back", :operator_name_form, "/operator-name/back"
    include_examples "POST form", :operator_name_form, "/operator-name" do
      let(:form_data) { { operator_name: "Acme Waste Carriers" } }
      let(:invalid_form_data) { [{ operator_name: nil }] }
    end

    context "when editing an existing registration" do
      let(:edit_operator_name_form) { build(:edit_operator_name_form) }

      it "prefils operator name information" do
        get "/waste_exemptions_engine/operator-name/#{edit_operator_name_form.token}"

        expect(response.body).to include(edit_operator_name_form.operator_name)
      end
    end

    context "when renewing an existing registration" do
      let(:renew_operator_name_form) { build(:renew_operator_name_form) }

      it "prefils operator name information" do
        get "/waste_exemptions_engine/operator-name/#{renew_operator_name_form.token}"

        expect(response.body).to include(renew_operator_name_form.operator_name)
      end
    end
  end
end
