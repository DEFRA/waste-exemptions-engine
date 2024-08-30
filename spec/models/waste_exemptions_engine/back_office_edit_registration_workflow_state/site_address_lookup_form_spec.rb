# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe BackOfficeEditRegistration do
    describe "#workflow_state" do
      it_behaves_like "site_address_lookup_form", :back_office_edit_registration, :back_office_edit_form
    end
  end
end
