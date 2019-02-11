# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe ExemptionsForm, type: :model do
    before(:context) do
      # Create a selection of exemptions. The ExemptionForm needs this as it
      # will validate the selected exemptions (our params) against the
      # collection of exemptions it pulls from the database.
      create_list(:exemption, 5)
    end

    it_behaves_like "a validated form", :exemptions_form do
      let(:valid_params) { { token: form.token, exemptions: %w[1 2 3] } }
      let(:invalid_params) { { token: form.token } }
    end
  end
end
