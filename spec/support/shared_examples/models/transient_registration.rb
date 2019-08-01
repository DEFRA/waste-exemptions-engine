# frozen_string_literal: true

RSpec.shared_examples "a transient_registration" do |model_factory|
  subject(:transient_registration) { create(model_factory) }

  describe "public interface" do
    Helpers::ModelProperties::TRANSIENT_REGISTRATION.each do |property|
      it "responds to property" do
        expect(transient_registration).to respond_to(property)
      end
    end
  end

  describe "#token" do
    context "when a transient registration is created" do
      it "has a token" do
        expect(transient_registration.token).not_to be_empty
      end
    end
  end

  describe "#registration_attributes" do
    it "returns valid registration attributes from the transient registration" do
      attributes = transient_registration.registration_attributes
      registration_attributes = Helpers::ModelProperties::REGISTRATION.map(&:to_s) - ["submitted_at", "reference"]
      expect(attributes.keys).to match_array(registration_attributes)
    end
  end

  it_behaves_like "an owner of registration attributes", model_factory, :transient_address
end
