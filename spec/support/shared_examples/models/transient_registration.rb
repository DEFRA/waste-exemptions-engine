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

  describe "associations" do
    subject(:transient_registration) { create(model_factory, :with_all_addresses) }

    describe "#transient_site_address" do
      it "returns an TransientAddress of type :site" do
        expect(transient_registration.transient_site_address).to eq(transient_registration.site_address)
      end
    end

    describe "#transient_operator_address" do
      it "returns an TransientAddress of type :operator" do
        expect(transient_registration.transient_operator_address).to eq(transient_registration.operator_address)
      end
    end

    describe "#transient_contact_address" do
      it "returns an TransientAddress of type :contact" do
        expect(transient_registration.transient_contact_address).to eq(transient_registration.contact_address)
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
      registration_attributes = Helpers::ModelProperties::REGISTRATION.map(&:to_s) - %w[submitted_at reference]
      expect(attributes.keys).to include(*registration_attributes)
    end
  end

  it_behaves_like "an owner of registration attributes", model_factory, :transient_address
end
