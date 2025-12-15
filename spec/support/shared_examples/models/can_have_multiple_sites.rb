# frozen_string_literal: true

RSpec.shared_examples "can have multiple sites" do |model_factory|

  describe "#multisite?" do
    subject(:instance) { create(model_factory, is_multisite_registration:) }

    context "when is_multisite_registration is false" do
      let(:is_multisite_registration) { false }

      it { expect(instance.multisite?).to be false }
    end

    context "when is_multisite_registration is true" do
      let(:is_multisite_registration) { true }

      it { expect(instance.multisite?).to be true }
    end

    context "when is_multisite_registration is nil" do
      let(:is_multisite_registration) { nil }

      it { expect(instance.multisite?).to be false }
    end
  end
end
