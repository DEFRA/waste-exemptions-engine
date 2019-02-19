# frozen_string_literal: true

RSpec.shared_examples "an invalid record" do |validatable, property, error_message|
  it "confirms the object is invalid" do
    expect(validatable).to_not be_valid
  end

  it "adds a single validation error to the record" do
    validatable.valid?
    expect(validatable.errors[property].count).to eq(1)
  end

  it "adds an appropriate validation error" do
    validatable.valid?
    expect(error_message).to_not include("translation missing:")
    expect(validatable.errors[property]).to eq([error_message])
  end
end
