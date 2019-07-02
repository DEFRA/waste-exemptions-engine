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

        context "when the feature toggle contains a typo in the rreturn value" do
          it "returns false" do
            expect(described_class.active?("broken_test_feature")).to be_falsey
          end
        end

        context "when the feature toggle contains a typo in the structure level" do
          it "returns false" do
            expect(described_class.active?("broken_test_feature_2")).to be_falsey
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
