# frozen_string_literal: true

require "spec_helper"

RSpec.shared_examples_for "can_convert_pence_to_pounds" do |factory_name, field|
  let(:object) { build(factory_name.to_s.underscore.to_sym, field => 100) }

  it "has a {field}_in_pounds field" do
    expect(object.send(:"#{field}_in_pounds")).to be_present
  end

  it "{field}_in_pounds is correctly converted" do
    expect(object.send(:"#{field}_in_pounds")).to eq(format("%.2f", object.send(field).to_f / 100))
  end

  it "can set {field}_in_pounds" do
    object.send(:"#{field}_in_pounds=", "1.23")
    expect(object.send(field)).to eq(123)
  end

  it "validates {field}_in_pounds when price is invalid" do
    object.send(:"#{field}_in_pounds=", "1.23aa")
    object.send(:"validate_#{field}_in_pounds")
    expect(object.errors[:"#{field}_in_pounds"]).to include("is not a valid price")
  end

  it "validates {field}_in_pound when price is valid" do
    object.send(:"#{field}_in_pounds=", "1.23")
    object.send(:"validate_#{field}_in_pounds")
    expect(object.errors[:"#{field}_in_pounds"]).to be_empty
  end
end
