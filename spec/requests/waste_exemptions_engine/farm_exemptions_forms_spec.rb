# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Farm Exemptions Forms" do

    include_context "farm bucket"

    let(:form_data) { { temp_exemptions: Exemption.limit(3).pluck(:id) } }

    it_behaves_like "GET form", :farm_exemptions_form, "/select-farm-waste-exemptions", is_charged: true
    it_behaves_like "POST form", :farm_exemptions_form, "/select-farm-waste-exemptions", empty_form_is_valid: true do
      let(:form_data) { { temp_exemptions: Exemption.limit(3).pluck(:id) } }
    end

    context "when presenting the form" do
      let(:farm_exemptions_form) { build(:farm_exemptions_form) }

      before do
        get "/waste_exemptions_engine/#{farm_exemptions_form.token}/select-farm-waste-exemptions"
      end

      it "displays the farming exemptions" do
        farm_exemptions.each do |exemption|
          expect(response.body).to include exemption.code
        end
      end

      it "does not display the non-farming exemptions" do
        non_farm_exemptions.each do |exemption|
          expect(response.body).not_to include exemption.code
        end
      end
    end

    context "when adding farming exemptions" do
      let(:farm_exemptions_form) { build(:farm_exemptions_form) }

      it "directs to confirm farm activity exemptions form when submitted" do
        post "/waste_exemptions_engine/#{farm_exemptions_form.token}/select-farm-waste-exemptions",
             params: { farm_exemptions_form: form_data }

        expect(response).to redirect_to(confirm_farm_exemptions_forms_path(farm_exemptions_form.token))
      end
    end
  end
end
