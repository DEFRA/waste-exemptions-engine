# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Check Contact Name Forms" do
    it_behaves_like "GET form", :check_contact_name_form, "/check-contact-name"
    it_behaves_like "POST form", :check_contact_name_form, "/check-contact-name" do
      let(:form_data) { { temp_reuse_applicant_name: "true" } }
      let(:invalid_form_data) { [{ temp_reuse_applicant_name: "" }] }
    end
  end
end
