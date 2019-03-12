# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Applicant Email Forms", type: :request do
    include_examples "GET form", :applicant_email_form, "/applicant-email"
    include_examples "go back", :applicant_email_form, "/applicant-email/back"
    include_examples "POST form", :applicant_email_form, "/applicant-email" do
      let(:form_data) { { applicant_email: "test@example.com", confirmed_email: "test@example.com" } }
    end
  end
end
