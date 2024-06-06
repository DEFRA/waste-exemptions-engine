# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe RegularChargingStrategy do
    include_context "with bands and charges"
    include_context "with an order with exemptions"

    describe "#charge_details" do
      it_behaves_like "non-bucket charging strategy #charge_details"
    end
  end
end
