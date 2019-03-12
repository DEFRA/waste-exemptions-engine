# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Contact Phone Forms", type: :request do
    include_examples "GET form", :contact_phone_form, "/contact-phone"
    include_examples "go back", :contact_phone_form, "/contact-phone/back"
    include_examples "POST form", :contact_phone_form, "/contact-phone" do
      let(:form_data) { { phone_number: "01234567890" } }
    end
  end
end
