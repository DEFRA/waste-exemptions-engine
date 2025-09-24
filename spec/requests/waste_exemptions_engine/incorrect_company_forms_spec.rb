# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Incorrect Company Forms" do
    let(:incorrect_company_form) { build(:incorrect_company_form) }
    let(:request_path) { "/waste_exemptions_engine/#{incorrect_company_form.token}/incorrect-company" }

    empty_form_is_valid = true
    it_behaves_like "GET form", :incorrect_company_form, "/incorrect-company"
    it_behaves_like "POST form", :incorrect_company_form, "/incorrect-company", empty_form_is_valid do
      let(:form_data) { {} }
      let(:invalid_form_data) { [] }
    end

    shared_examples "diplays the prompt to enter a different number" do
      it "displays a link to enter a different number" do
        get request_path

        expect(response.body).to have_html_escaped_string(
          I18n.t(".waste_exemptions_engine.incorrect_company_forms.new.enter_a_different_number")
        )
      end
    end

    context "with a new registration" do
      let(:new_registration) { build(:new_registration, temp_company_no: "12345678") }

      it_behaves_like "diplays the prompt to enter a different number"
    end

    context "with a new charged registration" do
      let(:new_registration) { build(:new_charged_registration, temp_company_no: "12345678") }

      it_behaves_like "diplays the prompt to enter a different number"
    end
  end
end
