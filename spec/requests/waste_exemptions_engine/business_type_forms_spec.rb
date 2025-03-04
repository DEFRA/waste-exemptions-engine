# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Business Type Forms" do
    include_examples "GET form", :business_type_form, "/business-type"
    include_examples "POST form", :business_type_form, "/business-type" do
      let(:form_data) { { business_type: "limitedCompany" } }
      let(:invalid_form_data) { [{ business_type: nil }] }
    end

    describe "POST business_type_form with charity" do
      let(:form) { build(:business_type_form) }

      context "when in front office" do
        before do
          allow(WasteExemptionsEngine.configuration).to receive(:host_is_back_office?).and_return(false)
          # Ensure it's not assisted digital
          form.transient_registration.update(assistance_mode: "self_serve")
        end

        it "redirects to the charity register free form when charity is selected" do
          post_form_with_params(form, business_type: "charity")
          expect(response).to redirect_to(new_charity_register_free_form_path(form.token))
        end

        it "updates the business_type on the transient registration" do
          post_form_with_params(form, business_type: "charity")
          expect(form.transient_registration.reload.business_type).to eq("charity")
        end

        it "updates the workflow state to charity_register_free_form" do
          post_form_with_params(form, business_type: "charity")
          expect(form.transient_registration.reload.workflow_state).to eq("charity_register_free_form")
        end

        context "when it is assisted digital" do
          before do
            form.transient_registration.update(assistance_mode: "assisted_digital")
          end

          it "follows the normal workflow for assisted digital" do
            post_form_with_params(form, business_type: "charity")
            expect(response).not_to redirect_to(new_charity_register_free_form_path(form.token))
          end
        end
      end

      context "when in back office" do
        before do
          allow(WasteExemptionsEngine.configuration).to receive(:host_is_back_office?).and_return(true)
        end

        it "follows the normal workflow" do
          post_form_with_params(form, business_type: "charity")
          expect(response).not_to redirect_to(new_charity_register_free_form_path(form.token))
        end
      end

      def post_form_with_params(form, params = {})
        post business_type_forms_path(form.token), params: { business_type_form: params }
      end
    end
  end
end
