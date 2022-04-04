# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Check Contact Address Forms", type: :request do
    include_examples "GET form", :check_contact_address_form, "/check-contact-address"
    include_examples "go back", :check_contact_address_form, "/check-contact-address/back"
    include_examples "POST form", :check_contact_address_form, "/check-contact-address" do
      let(:form_data) { { temp_reuse_operator_address: "true" } }
      let(:invalid_form_data) { [{ temp_reuse_operator_address: "" }] }
    end
  end
end
