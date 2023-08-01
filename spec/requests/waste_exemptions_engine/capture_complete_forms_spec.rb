# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Registration Lookup Complete Forms" do
    let(:registration) { create(:registration, :with_active_exemptions) }
    let(:capture_complete_form) { build(:capture_complete_form) }

    include_examples "GET form", :capture_complete_form, "/registration-lookup-complete/"
  end
end
