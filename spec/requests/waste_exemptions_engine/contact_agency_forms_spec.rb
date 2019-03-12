# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Contact Agency Forms", type: :request do
    include_examples "GET form", :contact_agency_form, "/contact-agency"
    include_examples "go back", :contact_agency_form, "/contact-agency/back"
    include_examples "unable to POST form", :contact_agency_form, "/contact-agency"
  end
end
