# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Contact Postcode Forms", type: :request do
    include_examples "GET form", :contact_postcode_form, "/contact-postcode"
    include_examples "go back", :contact_postcode_form, "/contact-postcode/back"
    include_examples "POST form", :contact_postcode_form, "/contact-postcode" do
      let(:form_data) { { postcode: "BS1 5AH" } }
    end

    include_examples "skip to manual address",
                     :contact_postcode_form,
                     request_path: "/contact-postcode/skip_to_manual_address",
                     result_path: "/contact-address-manual"
  end
end
