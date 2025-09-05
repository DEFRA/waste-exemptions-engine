# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe CanHaveMultipleSites do
    let(:test_class) do
      Class.new do
        include CanHaveMultipleSites
        
        def site_addresses
          @site_addresses ||= []
        end
        
        def site_addresses=(addresses)
          @site_addresses = addresses
        end
      end
    end
    
    let(:instance) { test_class.new }

    describe "#multisite?" do
      context "when there is one or no site addresses" do
        it "returns false for empty addresses" do
          instance.site_addresses = []
          expect(instance.multisite?).to be false
        end

        it "returns false for single address" do
          instance.site_addresses = [double("address")]
          expect(instance.multisite?).to be false
        end
      end

      context "when there are multiple site addresses" do
        it "returns true" do
          instance.site_addresses = [double("address1"), double("address2")]
          expect(instance.multisite?).to be true
        end
      end
    end

    describe "#site_count" do
      it "returns the count of site addresses" do
        instance.site_addresses = [double("address1"), double("address2"), double("address3")]
        expect(instance.site_count).to eq(3)
      end

      it "returns 0 for empty addresses" do
        instance.site_addresses = []
        expect(instance.site_count).to eq(0)
      end
    end
  end
end
