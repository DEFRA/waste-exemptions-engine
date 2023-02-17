# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Deregistration Complete No Change Forms" do
    let(:form) { build(:deregistration_complete_no_change_form) }

    include_examples "GET form", :deregistration_complete_no_change_form, "/deregistration-complete-no-change"
    include_examples "unable to POST form", :deregistration_complete_no_change_form, "/deregistration-complete-no-change"
  end
end
