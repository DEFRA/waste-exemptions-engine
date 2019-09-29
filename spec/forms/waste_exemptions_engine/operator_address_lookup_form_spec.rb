# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe OperatorAddressLookupForm, type: :model do
    it_behaves_like "an address lookup form", :operator_address_lookup_form
  end
end
