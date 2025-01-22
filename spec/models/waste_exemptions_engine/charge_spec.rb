# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe Charge do
    describe "public interface" do
      subject(:charge) { build(:charge) }

      Helpers::ModelProperties::CHARGE.each do |property|
        it "responds to property" do
          expect(charge).to respond_to(property)
        end
      end

      context "when charge has CanConvertPenceToPounds concern included" do
        it_behaves_like "can_convert_pence_to_pounds", "charge", :charge_amount
      end
    end
  end
end
