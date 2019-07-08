# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Applicant Email Forms", type: :request do
    include_examples "GET form", :applicant_email_form, "/applicant-email"
    include_examples "go back", :applicant_email_form, "/applicant-email/back"
    include_examples "POST form", :applicant_email_form, "/applicant-email" do
      let(:form_data) { { applicant_email: "test@example.com", confirmed_email: "test@example.com" } }
      let(:invalid_form_data) do
        [
          { applicant_email: "foo", confirmed_email: "Bar" },
          { applicant_email: nil, confirmed_email: nil },
          { applicant_email: "test@email.com", confirmed_email: "different-test@email.com" }
        ]
      end
    end
  end
end
