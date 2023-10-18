# frozen_string_literal: true

RSpec.shared_examples "an invalid record" do |validatable, property, error_message|
  it "confirms the object is invalid" do
    expect(validatable).not_to be_valid
  end

  it "adds a single validation error to the record" do
    validatable.valid?
    expect(validatable.errors[property].count).to eq(1)
  end

  it "has a valid translation" do
    validatable.valid?
    expect(error_message).not_to include("translation missing:")
  end

  it "adds an appropriate validation error" do
    validatable.valid?
    expect(validatable.errors[property]).to eq([error_message])
  end
end
