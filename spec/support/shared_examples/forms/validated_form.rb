# frozen_string_literal: true

RSpec.shared_examples "a validated form" do |form_factory|
  subject(:form) { build(form_factory) }

  let(:valid_params) do
    { override_me: "Set :valid_params in the calling spec." }
  end
  let(:invalid_params) do
    { override_me: "Set :invalid_params in the calling spec." }
  end

  it "is a type of BaseForm" do
    expect(described_class.ancestors)
      .to include(WasteExemptionsEngine::BaseForm)
  end

  describe "#submit" do
    context "when the form is valid" do
      it "submits" do
        # Handle both single sets of valid params as well as multiple sets of valid params.
        params = valid_params.is_a?(Array) ? valid_params : [valid_params]
        params.each do |valid_param_set|
          expect(form.submit(ActionController::Parameters.new(valid_param_set).permit!)).to be(true)
        end
      end
    end

    context "when the form is not valid" do
      it "does not submit" do
        # Handle both single sets of invalid params as well as multiple sets of invalid params.
        params = invalid_params.is_a?(Array) ? invalid_params : [invalid_params]
        params.each do |invalid_param_set|
          expect(form.submit(ActionController::Parameters.new(invalid_param_set).permit!)).to be(false)
        end
      end
    end
  end
end
