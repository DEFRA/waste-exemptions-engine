# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe NewRegistration do
    describe "#workflow_state" do
      it_behaves_like "site_address_lookup_form", :new_registration, :check_your_answers_form
    end
  end
end
