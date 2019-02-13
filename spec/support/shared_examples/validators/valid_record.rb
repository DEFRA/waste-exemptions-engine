# frozen_string_literal: true

RSpec.shared_examples "a valid record" do |validatable|
  # The method in this context is #validate_each
  it "gets called" do
    expect_any_instance_of(described_class)
      .to receive(:validate_each)
      .once

    validatable.valid?
  end

  it "confirms the object is valid" do
    expect(validatable).to be_valid
  end

  it "the errors are empty" do
    validatable.valid?
    expect(validatable.errors).to be_empty
  end
end
