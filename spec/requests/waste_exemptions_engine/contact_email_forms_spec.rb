# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Contact Email Forms", type: :request do
    include_examples "GET form", :contact_email_form, "/contact-email"
    include_examples "go back", :contact_email_form, "/contact-email/back"
    include_examples "POST form", :contact_email_form, "/contact-email" do
      let(:form_data) { { contact_email: "test@example.com", confirmed_email: "test@example.com" } }
    end
  end
end
