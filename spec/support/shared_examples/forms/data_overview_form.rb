# frozen_string_literal: true

RSpec.shared_examples "a data overview form", :vcr do |form_factory|
  let(:form) { build(form_factory) }
  let(:transient_registration) { build(:new_registration) }

  before do
    allow(WasteExemptionsEngine::TransientRegistration).to receive(:new).and_return(transient_registration)
  end

  it "includes DataOverviewForm" do
    included_modules = described_class.ancestors.select { |ancestor| ancestor.instance_of?(Module) }
    expect(included_modules).to include(WasteExemptionsEngine::DataOverviewForm)
  end

  describe "#should_have_company_no?" do
    context "when transient_registration requires a company_no" do
      before { allow(transient_registration).to receive(:company_no_required?).and_return(true) }

      it { expect(form.should_have_company_no?).to be true }
    end

    context "when transient_registration does not require a company_no" do
      before { allow(transient_registration).to receive(:company_no_required?).and_return(false) }

      it { expect(form.should_have_company_no?).to be false }
    end
  end

  describe "#should_have_partners?" do
    context "when transient_registration is a partnership" do
      before { allow(transient_registration).to receive(:partnership?).and_return(true) }

      it { expect(form.should_have_partners?).to be true }
    end

    context "when transient_registration is not a partnership" do
      before { allow(transient_registration).to receive(:partnership?).and_return(false) }

      it { expect(form.should_have_partners?).to be false }
    end
  end
end
