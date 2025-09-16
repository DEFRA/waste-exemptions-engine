# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Confirm Farm Exemptions Forms" do

    include_context "farm bucket"

    include_examples "GET form", :confirm_farm_exemptions_form, "/your-selected-farm-exemptions", is_charged: true
    include_examples "POST form", :confirm_farm_exemptions_form, "/your-selected-farm-exemptions" do
      let(:form_data) { { temp_add_additional_non_bucket_exemptions: "true" } }
      let(:invalid_form_data) { [{ temp_add_additional_non_bucket_exemptions: nil }] }
    end

    context "when adding exemptions in the new charged registration flow" do
      let(:confirm_farm_exemptions_form) { build(:new_charged_registration_flow_confirm_farm_exemptions_form) }

      before do
        create_list(:exemption, 5)
        confirm_farm_exemptions_form.transient_registration.update(temp_exemptions: WasteExemptionsEngine::Exemption.limit(5).pluck(:id))
      end

      it "directs to confirm activity exemptions form when submitted" do
        post "/waste_exemptions_engine/#{confirm_farm_exemptions_form.token}/your-selected-farm-exemptions",
             params: { confirm_farm_exemptions_form: { temp_add_additional_non_bucket_exemptions: "false" } }

        expect(response).to redirect_to(is_multisite_registration_forms_path(confirm_farm_exemptions_form.token))
      end
    end
  end
end
