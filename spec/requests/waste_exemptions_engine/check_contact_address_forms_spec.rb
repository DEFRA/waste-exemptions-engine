# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Check Contact Address Forms" do
    it_behaves_like "GET form", :check_contact_address_form, "/check-contact-address"
    it_behaves_like "POST form", :check_contact_address_form, "/check-contact-address" do
      let(:form_data) { { temp_reuse_operator_address: "true" } }
      let(:invalid_form_data) { [{ temp_reuse_operator_address: "" }] }
    end
  end
end
