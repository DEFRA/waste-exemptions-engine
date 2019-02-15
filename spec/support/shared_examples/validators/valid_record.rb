# frozen_string_literal: true

RSpec.shared_examples "a valid record" do |validatable|
  it "confirms the object is valid" do
    expect(validatable).to be_valid
  end

  it "the errors are empty" do
    validatable.valid?
    expect(validatable.errors).to be_empty
  end
end
