# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Private Beta Registration Complete Forms" do
    let(:form) { build(:private_beta_registration_complete_form) }

    include_examples "GET form", :private_beta_registration_complete_form, "/private-beta-registration-complete"
    include_examples "unable to POST form", :private_beta_registration_complete_form, "/private-beta-registration-complete"
  end
end
