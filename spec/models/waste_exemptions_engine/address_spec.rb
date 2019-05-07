# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe Address, type: :model do
    describe "public interface" do
      subject(:address) { build(:address) }

      associations = [:registration]

      (Helpers::ModelProperties::ADDRESS + associations).each do |property|
        it "responds to property" do
          expect(address).to respond_to(property)
        end
      end
    end

    describe "#located_by_grid_reference?" do
      subject { described_class.new(mode: mode) }

      context "when mode is manual" do
        let(:mode) { :manual }

        it "returns false" do
          expect(subject).to_not be_located_by_grid_reference
        end
      end

      context "when mode is auto" do
        let(:mode) { :auto }

        it "returns true" do
          expect(subject).to be_located_by_grid_reference
        end
      end
    end

    it_behaves_like "it has PaperTrail", model_factory: :address,
                                         field: :organisation,
                                         ignored_fields: %i[blpu_state_code
                                                            logical_status_code
                                                            country_iso
                                                            postal_address_code]
  end
end
