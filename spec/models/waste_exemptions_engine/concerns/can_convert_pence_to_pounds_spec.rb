# frozen_string_literal: true

require "spec_helper"

RSpec.shared_examples_for "can_convert_pence_to_pounds" do |factory_name, field|
  it "has a {field}_in_pounds field" do
    object = build(factory_name.to_s.underscore.to_sym, field => 100)
    expect(object.send(:"#{field}_in_pounds")).to be_present
  end

  it "{field}_in_pounds is correctly converted" do
    object = build(factory_name.to_s.underscore.to_sym, field => 100)
    expect(object.send(:"#{field}_in_pounds")).to eq(format("%.2f", object.send(field).to_f / 100))
  end
end
