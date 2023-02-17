# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Deregistration Complete Partial Forms" do
    let(:form) { build(:deregistration_complete_partial_form) }

    include_examples "GET form", :deregistration_complete_partial_form, "/deregistration-complete-partial"
    include_examples "unable to POST form", :deregistration_complete_partial_form, "/deregistration-complete-partial"
  end
end
