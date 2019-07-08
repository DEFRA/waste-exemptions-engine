# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Site Postcode Forms", type: :request do
    include_examples "GET form", :site_postcode_form, "/site-postcode"
    include_examples "go back", :site_postcode_form, "/site-postcode/back"
    include_examples "POST form", :site_postcode_form, "/site-postcode" do
      let(:form_data) { { postcode: "BS1 5AH" } }
      let(:invalid_form_data) { [{ postcode: "BS" }, { postcode: nil }] }
    end

    include_examples "skip to manual address",
                     :site_postcode_form,
                     request_path: "/site-postcode/skip_to_manual_address",
                     result_path: "/site-address-manual"
  end
end
