# frozen_string_literal: true

RSpec.shared_examples "it has PaperTrail" do |model_factory, field|
  subject(:instance) { create(model_factory) }

  it "creates a new version when it is updated" do
    expect { instance.update_attribute(field, "foo") }.to change { instance.versions.count }.by(1)
  end
end
