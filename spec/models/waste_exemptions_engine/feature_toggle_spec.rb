# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe FeatureToggle do
    describe ".active?" do
      context "when a feature toggle config exist" do
        context "when it is configured as active" do
          it "returns true" do
            expect(described_class.active?("active_test_feature")).to be_truthy
          end

          it "accept either strings or syms" do
            expect(described_class.active?(:active_test_feature)).to be_truthy
          end
        end

        context "when it is configured as not active" do
          it "returns false" do
            expect(described_class.active?("not_active_test_feature")).to be_falsey
          end
        end
      end

      context "when a feature toggle config does not exist" do
        it "returns false" do
          expect(described_class.active?("i_do_not_exist")).to be_falsey
        end
      end
    end
  end
end
