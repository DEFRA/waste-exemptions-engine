# frozen_string_literal: true

RSpec.shared_examples "an owner of registration attributes" do |model_factory, address_factory|
  subject(:instance) do
    create(model_factory, addresses: [operator_address, contact_address, site_address])
  end

  let(:operator_address) { create(address_factory, :operator_address) }
  let(:contact_address) { create(address_factory, :contact_address) }
  let(:site_address) { create(address_factory, :site_address) }

  it "includes CanHaveRegistrationAttributes" do
    included_modules = described_class.ancestors.select { |ancestor| ancestor.instance_of?(Module) }

    expect(included_modules)
      .to include(WasteExemptionsEngine::CanHaveRegistrationAttributes)
  end

  describe "#company_no_required?" do
    it "returns a boolean indicating whether a company number is required" do
      instance.business_type = WasteExemptionsEngine::TransientRegistration::BUSINESS_TYPES[:charity]
      expect(instance.company_no_required?).to be(false)
      instance.business_type = WasteExemptionsEngine::TransientRegistration::BUSINESS_TYPES[:limited_company]
      expect(instance.company_no_required?).to be(true)
      instance.business_type = WasteExemptionsEngine::TransientRegistration::BUSINESS_TYPES[:limited_liability_partnership]
      expect(instance.company_no_required?).to be(true)
      instance.business_type = WasteExemptionsEngine::TransientRegistration::BUSINESS_TYPES[:local_authority]
      expect(instance.company_no_required?).to be(false)
      instance.business_type = WasteExemptionsEngine::TransientRegistration::BUSINESS_TYPES[:partnership]
      expect(instance.company_no_required?).to be(false)
      instance.business_type = WasteExemptionsEngine::TransientRegistration::BUSINESS_TYPES[:sole_trader]
      expect(instance.company_no_required?).to be(false)
    end
  end

  describe "#partnership?" do
    it "returns true when the business type is a partnership else returns false" do
      instance.business_type = WasteExemptionsEngine::TransientRegistration::BUSINESS_TYPES[:charity]
      expect(instance.partnership?).to be(false)
      instance.business_type = WasteExemptionsEngine::TransientRegistration::BUSINESS_TYPES[:limited_company]
      expect(instance.partnership?).to be(false)
      instance.business_type = WasteExemptionsEngine::TransientRegistration::BUSINESS_TYPES[:limited_liability_partnership]
      expect(instance.partnership?).to be(false)
      instance.business_type = WasteExemptionsEngine::TransientRegistration::BUSINESS_TYPES[:local_authority]
      expect(instance.partnership?).to be(false)
      instance.business_type = WasteExemptionsEngine::TransientRegistration::BUSINESS_TYPES[:partnership]
      expect(instance.partnership?).to be(true)
      instance.business_type = WasteExemptionsEngine::TransientRegistration::BUSINESS_TYPES[:sole_trader]
      expect(instance.partnership?).to be(false)

    end
  end
end
