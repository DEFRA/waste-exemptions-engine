# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Registration Complete Forms" do
    let(:form) { build(:registration_complete_form) }

    include_examples "GET form", :registration_complete_form, "/registration-complete"
    include_examples "unable to POST form", :registration_complete_form, "/registration-complete"
  end
end
