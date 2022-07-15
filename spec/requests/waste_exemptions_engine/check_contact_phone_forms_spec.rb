# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Check Contact Phone Forms", type: :request do
    include_examples "GET form", :check_contact_phone_form, "/check-contact-phone"
    include_examples "POST form", :check_contact_phone_form, "/check-contact-phone" do
      let(:form_data) { { temp_reuse_applicant_phone: "true" } }
      let(:invalid_form_data) { [{ temp_reuse_applicant_phone: "" }] }
    end
  end
end
