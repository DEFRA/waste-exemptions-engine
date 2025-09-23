# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Registration Complete Forms" do
    let(:form) { build(:registration_complete_form) }

    it_behaves_like "GET form", :registration_complete_form, "/registration-complete"
    it_behaves_like "unable to POST form", :registration_complete_form, "/registration-complete"
  end
end
