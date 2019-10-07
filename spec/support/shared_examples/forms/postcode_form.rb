# frozen_string_literal: true

RSpec.shared_examples "a postcode form" do |form_factory|
  it_behaves_like "a validated form", form_factory do
    let(:valid_params) { { postcode: "BS1 5AH" } }
    let(:invalid_params) { { postcode: "foo" } }
  end

  it "is a type of PostcodeForm" do
    expect(described_class.ancestors)
      .to include(WasteExemptionsEngine::PostcodeForm)
  end

  it "validates the postcode using the PostcodeValidator class" do
    validators = build(form_factory)._validators
    expect(validators.keys).to include(:postcode)
    expect(validators[:postcode].first.class)
      .to eq(WasteExemptionsEngine::PostcodeValidator)
  end

  describe "#submit" do
    context "when the form is valid" do
      it "updates the transient registration with the selected postcode" do
        form = build(form_factory)
        postcode = "BS1 5AH"
        valid_params = { postcode: postcode }
        transient_registration = form.transient_registration

        # Accessing private methods directly is usually best avoided, but this seemed to be the only
        # way to programmitcally retreive the appropriate postcode field without exposing additional
        # information to the public interface.
        postcode_field = form.send(:determine_temp_postcode_field_name)

        expect(transient_registration.public_send(postcode_field)).to be_blank
        form.submit(valid_params)
        expect(transient_registration.public_send(postcode_field)).to eq(postcode)
      end
    end
  end
end
