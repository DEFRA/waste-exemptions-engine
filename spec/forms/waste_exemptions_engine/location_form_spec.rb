# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe LocationForm, type: :model do
    subject(:form) { build(:location_form) }

    locations = %w[
      england
      northern_ireland
      scotland
      wales
    ].freeze

    it "validates the location using the LocationValidator class" do
      validators = form._validators
      expect(validators.keys).to include(:location)
      expect(validators[:location].first.class)
        .to eq(DefraRuby::Validators::LocationValidator)
    end

    it_behaves_like "a validated form", :location_form do
      let(:valid_params) { { location: locations.sample } }
      let(:invalid_params) do
        [
          { location: "foo" },
          { location: "" }
        ]
      end
    end

    describe "#submit" do
      context "when the form is valid" do
        it "updates the transient registration with the location" do
          location = locations.sample
          valid_params = { location: location }
          transient_registration = form.transient_registration

          expect(transient_registration.location).to be_blank
          form.submit(valid_params)
          expect(transient_registration.location).to eq(location)
        end
      end
    end
  end
end
