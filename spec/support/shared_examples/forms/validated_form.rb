# frozen_string_literal: true

RSpec.shared_examples "a validated form" do |form_factory|
  subject(:form) { build(form_factory) }
  let(:valid_params) do
    { override_me: 'Set :valid_params in the calling spec.' }
  end
  let(:invalid_params) do
    { override_me: 'Set :invalid_params in the calling spec.' }
  end

  it "should be a type of BaseForm" do
    expect(described_class.ancestors)
      .to include(WasteExemptionsEngine::BaseForm)
  end

  describe "#submit" do
    context "when the form is valid" do
      it "should submit" do
        expect(form.submit(valid_params)).to eq(true)
      end
    end

    context "when the form is not valid" do
      it "should not submit" do
        expect(form.submit(invalid_params)).to eq(false)
      end
    end
  end
end
