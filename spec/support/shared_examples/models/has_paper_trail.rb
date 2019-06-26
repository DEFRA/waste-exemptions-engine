# frozen_string_literal: true

RSpec.shared_examples "it has PaperTrail", versioning: true do |model_factory:, field:, ignored_fields: nil|
  subject(:instance) { create(model_factory) }

  it "has PaperTrail" do
    expect(PaperTrail).to be_enabled
  end

  it "is versioned" do
    expect(instance).to be_versioned
  end

  it "creates a new version when it is updated" do
    expect { instance.update_attribute(field, "foo") }.to change { instance.versions.count }.by(1)
  end

  it "stores the correct values when it is updated" do
    instance.update_attribute(field, "foo")
    instance.update_attribute(field, "bar")
    expect(instance).to have_a_version_with(field => "foo")
  end

  it "stores a JSON record of all the data" do
    expected_json = JSON.parse(instance.to_json)
    instance.paper_trail.save_with_version
    expect(instance.versions.last.json).to eq(expected_json)
  end

  it "does not create a version when an ignored attribute is updated" do
    if ignored_fields.present?
      ignored_fields.each do |ignored_field|
        expect { instance.update_attribute(ignored_field, "foo") }.to change { instance.versions.count }.by(0)
      end
    end
  end
end
