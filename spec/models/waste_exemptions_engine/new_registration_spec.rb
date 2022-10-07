# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe NewRegistration, type: :model do
    subject(:new_registration) { create(:new_registration) }

    it_behaves_like "a transient_registration", :new_registration

    it "subclasses TransientRegistration" do
      expect(described_class).to be < TransientRegistration
    end

    describe "public interface" do
      Helpers::ModelProperties::TRANSIENT_REGISTRATION.each do |property|
        it "responds to property" do
          expect(new_registration).to respond_to(property)
        end
      end
    end

    describe "#renewal?" do
      it "returns false" do
        expect(new_registration).not_to be_a_renewal
      end
    end

    describe "#assistance_mode" do

      context "when the default_assistance_mode is set" do
        before do
          allow(WasteExemptionsEngine.configuration).to receive(:default_assistance_mode).and_return("foo")
        end

        it "sets a new NewRegistration's assistance_mode to the correct value" do
          expect(new_registration.assistance_mode).to eq("foo")
        end
      end

      context "when the default_assistance_mode is not set" do
        before do
          allow(WasteExemptionsEngine.configuration).to receive(:default_assistance_mode).and_return(nil)
        end

        it "sets a new NewRegistration's assistance_mode to nil" do
          expect(new_registration.assistance_mode).to be_nil
        end
      end
    end
  end
end
