# frozen_string_literal: true

RSpec.shared_examples "an owner of registration attributes" do |model_factory, address_factory|
  let(:operator_address) { create(address_factory, :operator_address) }
  let(:contact_address) { create(address_factory, :contact_address) }
  let(:site_address) { create(address_factory, :site_address) }
  subject(:instance) do
    create(model_factory, addresses: [operator_address, contact_address, site_address])
  end

  it "includes CanHaveRegistrationAttributes" do
    included_modules = described_class.ancestors.select { |ancestor| ancestor.instance_of?(Module) }

    expect(included_modules)
      .to include(WasteExemptionsEngine::CanHaveRegistrationAttributes)
  end

  describe "#company_no_required?" do
    it "returns a boolean indicating whether a company number is required" do
      instance.business_type = "charity"
      expect(instance.company_no_required?).to eq(false)
      instance.business_type = "limitedCompany"
      expect(instance.company_no_required?).to eq(true)
      instance.business_type = "limitedLiabilityPartnership"
      expect(instance.company_no_required?).to eq(true)
      instance.business_type = "localAuthority"
      expect(instance.company_no_required?).to eq(false)
      instance.business_type = "partnership"
      expect(instance.company_no_required?).to eq(false)
      instance.business_type = "soleTrader"
      expect(instance.company_no_required?).to eq(false)
    end
  end

  describe "#partnership?" do
    it "returns true when the business type is a partnership else returns false" do
      instance.business_type = "charity"
      expect(instance.partnership?).to eq(false)
      instance.business_type = "limitedCompany"
      expect(instance.partnership?).to eq(false)
      instance.business_type = "limitedLiabilityPartnership"
      expect(instance.partnership?).to eq(false)
      instance.business_type = "localAuthority"
      expect(instance.partnership?).to eq(false)
      instance.business_type = "partnership"
      expect(instance.partnership?).to eq(true)
      instance.business_type = "soleTrader"
      expect(instance.partnership?).to eq(false)

    end
  end

  describe "#operator_address" do
    it "returns the operator address" do
      expect(instance.operator_address).to eq(operator_address)
    end
  end

  describe "#contact_address" do
    it "returns the contact address" do
      expect(instance.contact_address).to eq(contact_address)
    end
  end

  describe "#site_address" do
    it "returns the site address" do
      expect(instance.site_address).to eq(site_address)
    end
  end
end
