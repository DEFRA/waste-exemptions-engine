# frozen_string_literal: true

RSpec.shared_examples "a changer of the exemption status" do |model_factory|
  subject(:instance) { create(model_factory) }

  it "includes CanChangeExemptionStatus" do
    included_modules = described_class.ancestors.select { |ancestor| ancestor.instance_of?(Module) }

    expect(included_modules)
      .to include(WasteExemptionsEngine::CanChangeExemptionStatus)
  end

  describe "#activate_exemption" do
    it "updates the registration and expiration dates of exemption" do
      registration_date = Date.today
      expiration_date = registration_date + WasteExemptionsEngine.configuration.years_before_expiry.years - 1.day

      expect(instance.registered_on).to eq(nil)
      expect(instance.expires_on).to eq(nil)
      instance.activate_exemption
      expect(instance.registered_on).to eq(registration_date)
      expect(instance.expires_on).to eq(expiration_date)
    end
  end
end
