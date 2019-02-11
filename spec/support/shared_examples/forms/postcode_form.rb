# frozen_string_literal: true

RSpec.shared_examples "a postcode form" do |form_factory|
  it_behaves_like "a validated form", form_factory do
    let(:valid_params) { { token: form.token, postcode: 'BS1 5AH' } }
    let(:invalid_params) { { token: form.token, postcode: 'foo' } }
  end

  it 'is a type of PostcodeForm' do
    expect(described_class.ancestors)
      .to include(WasteExemptionsEngine::PostcodeForm)
  end

  it "validates the postcode using the PostcodeValidator class" do
    validators = build(form_factory)._validators
    expect(validators.keys()).to include(:postcode)
    expect(validators[:postcode].first.class)
      .to eq(WasteExemptionsEngine::PostcodeValidator)
  end
end
