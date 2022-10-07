# frozen_string_literal: true

# rubocop:disable RSpec/AnyInstance
RSpec.shared_examples "a data overview form", vcr: true do |form_factory|
  let(:form) { build(form_factory) }

  it "includes DataOverviewForm" do
    included_modules = described_class.ancestors.select { |ancestor| ancestor.instance_of?(Module) }
    expect(included_modules).to include(WasteExemptionsEngine::DataOverviewForm)
  end

  describe "#should_have_company_no?" do
    context "when transient_registration requires a company_no" do
      before do
        allow_any_instance_of(WasteExemptionsEngine::TransientRegistration).to receive(:company_no_required?).and_return(true)
      end

      it "returns true" do
        expect(form.should_have_company_no?).to be true
      end
    end

    context "when transient_registration does not require a company_no" do
      before do
        allow_any_instance_of(WasteExemptionsEngine::TransientRegistration).to receive(:company_no_required?).and_return(false)
      end

      it "returns false" do
        expect(form.should_have_company_no?).to be false
      end
    end
  end

  describe "#should_have_partners?" do
    context "when transient_registration is a partnership" do
      before do
        allow_any_instance_of(WasteExemptionsEngine::TransientRegistration).to receive(:partnership?).and_return(true)
      end

      it "returns true" do
        expect(form.should_have_partners?).to be true
      end
    end

    context "when transient_registration is not a partnership" do
      before do
        allow_any_instance_of(WasteExemptionsEngine::TransientRegistration).to receive(:partnership?).and_return(false)
      end

      it "returns false" do
        expect(form.should_have_partners?).to be false
      end
    end
  end
end
# rubocop:enable RSpec/AnyInstance
