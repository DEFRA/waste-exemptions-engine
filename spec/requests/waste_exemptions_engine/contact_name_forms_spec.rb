# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Contact Name Forms", type: :request do
    include_examples "GET form", :contact_name_form, "/contact-name"
    include_examples "go back", :contact_name_form, "/contact-name/back"
    include_examples "POST form", :contact_name_form, "/contact-name" do
      let(:form_data) { { first_name: "Joe", last_name: "Bloggs" } }
    end
  end
end
