# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe ContactAddressLookupForm, type: :model do
    it_behaves_like "an address lookup form", :contact_address_lookup_form
  end
end
