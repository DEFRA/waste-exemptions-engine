# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Check Contact Phone Forms" do
    it_behaves_like "GET form", :check_contact_phone_form, "/check-contact-phone"
    it_behaves_like "POST form", :check_contact_phone_form, "/check-contact-phone" do
      let(:form_data) { { temp_reuse_applicant_phone: "true" } }
      let(:invalid_form_data) { [{ temp_reuse_applicant_phone: "" }] }
    end
  end
end
