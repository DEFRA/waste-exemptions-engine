# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe SiteAddressLookupForm, type: :model do
    it_behaves_like "an address lookup form", :site_address_lookup_form
  end
end
