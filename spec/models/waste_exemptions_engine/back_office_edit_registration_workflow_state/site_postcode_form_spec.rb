# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe BackOfficeEditRegistration do
    describe "#workflow_state" do
      it_behaves_like "a simple progressing transition",
                      current_state: :site_postcode_form,
                      next_state: :site_address_lookup_form,
                      factory: :back_office_edit_registration
    end
  end
end
