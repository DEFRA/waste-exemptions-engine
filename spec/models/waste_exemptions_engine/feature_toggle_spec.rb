# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe FeatureToggle do
    describe ".active?" do
      context "when a record exists with the given key" do
        let(:key) { "toggle_1" }

        before do
          create(:feature_toggle, key: key, active: active)
        end

        context "and the toggle is active" do
          let(:active) { "true" }

          it "returns true" do
            expect(described_class.active?(key)).to eq(true)
          end
        end

        context "and the toggle is not active" do
          let(:active) { false }

          it "returns false" do
            expect(described_class.active?(key)).to eq(false)
          end
        end
      end

      context "when a record does not exist with the given key" do
        context "but a feature toggle exists in 'config/feature_toggles.yml'" do
          context "and it is configured as active" do
            it "returns true" do
              expect(described_class.active?("active_test_feature")).to be_truthy
            end

            it "accepts either strings or symbols" do
              expect(described_class.active?(:active_test_feature)).to be_truthy
            end
          end

          context "and it is configured as not active" do
            it "returns false" do
              expect(described_class.active?("not_active_test_feature")).to be_falsey
            end
          end

          context "and the feature toggle contains a typo in the return value" do
            it "returns false" do
              expect(described_class.active?("broken_test_feature")).to be_falsey
            end
          end

          context "and the feature toggle contains a typo in the structure level" do
            it "returns false" do
              expect(described_class.active?("broken_test_feature_2")).to be_falsey
            end
          end

          context "and the feature toggle is a string containing 'true'" do
            it "returns true" do
              expect(described_class.active?("string_true_test_feature")).to be_truthy
            end
          end

          context "and the feature toggle is an environment variable" do
            before do
              # Change the environment variable value for this test only
              stub_const('ENV', ENV.to_hash.merge('ENV_VARIABLE_TEST_FEATURE' => 'true'))
              # Force reload of the toggle settings after setting the environment variable
              described_class.send('reload_feature_toggles')
            end

            it "returns true" do
              expect(described_class.active?("env_variable_test_feature")).to be_truthy
            end
          end
        end

        context "and a feature toggle does not exist in 'config/feature_toggles.yml'" do
          it "returns false" do
            expect(described_class.active?("i_do_not_exist")).to be_falsey
          end
        end
      end
    end
  end
end
