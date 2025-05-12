# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Check Contact Email Forms" do
    it_behaves_like "GET form", :check_contact_email_form, "/check-contact-email"
    it_behaves_like "POST form", :check_contact_email_form, "/check-contact-email" do
      let(:form_data) { { temp_reuse_applicant_email: "true" } }
      let(:invalid_form_data) { [{ temp_reuse_applicant_email: "" }] }
    end
  end
end
