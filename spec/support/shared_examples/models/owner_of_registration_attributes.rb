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
    shared_examples "company number is required" do |business_type|
      before { instance.business_type = business_type }

      it { expect(instance.company_no_required?).to be(true) }
    end

    shared_examples "company number is not required" do |business_type|
      before { instance.business_type = business_type }

      it { expect(instance.company_no_required?).to be(false) }
    end

    [
      WasteExemptionsEngine::TransientRegistration::BUSINESS_TYPES[:limited_company],
      WasteExemptionsEngine::TransientRegistration::BUSINESS_TYPES[:limited_liability_partnership]
    ].each { |business_type| it_behaves_like "company number is required", business_type }

    [
      WasteExemptionsEngine::TransientRegistration::BUSINESS_TYPES[:charity],
      WasteExemptionsEngine::TransientRegistration::BUSINESS_TYPES[:local_authority],
      WasteExemptionsEngine::TransientRegistration::BUSINESS_TYPES[:partnership],
      WasteExemptionsEngine::TransientRegistration::BUSINESS_TYPES[:sole_trader]
    ].each { |business_type| it_behaves_like "company number is not required", business_type }
  end

  describe "#partnership?" do
    shared_examples "is a partnership" do |business_type|
      before { instance.business_type = business_type }

      it { expect(instance.partnership?).to be(true) }
    end

    shared_examples "is not a partnership" do |business_type|
      before { instance.business_type = business_type }

      it { expect(instance.partnership?).to be(false) }
    end

    it_behaves_like "is a partnership", WasteExemptionsEngine::TransientRegistration::BUSINESS_TYPES[:partnership]

    [
      WasteExemptionsEngine::TransientRegistration::BUSINESS_TYPES[:charity],
      WasteExemptionsEngine::TransientRegistration::BUSINESS_TYPES[:limited_company],
      WasteExemptionsEngine::TransientRegistration::BUSINESS_TYPES[:limited_liability_partnership],
      WasteExemptionsEngine::TransientRegistration::BUSINESS_TYPES[:local_authority],
      WasteExemptionsEngine::TransientRegistration::BUSINESS_TYPES[:sole_trader]
    ].each { |business_type| it_behaves_like "is not a partnership", business_type }
  end
end
