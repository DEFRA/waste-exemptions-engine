# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Deregistration Complete Full Forms" do
    let(:form) { build(:deregistration_complete_full_form) }

    include_examples "GET form", :deregistration_complete_full_form, "/deregistration-complete-full"
    include_examples "unable to POST form", :deregistration_complete_full_form, "/deregistration-complete-full"
  end
end
