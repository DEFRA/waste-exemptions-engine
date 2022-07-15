# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Check Contact Name Forms", type: :request do
    include_examples "GET form", :check_contact_name_form, "/check-contact-name"
    include_examples "POST form", :check_contact_name_form, "/check-contact-name" do
      let(:form_data) { { temp_reuse_applicant_name: "true" } }
      let(:invalid_form_data) { [{ temp_reuse_applicant_name: "" }] }
    end
  end
end
