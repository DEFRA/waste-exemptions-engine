# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe StartForm, type: :model do
    subject(:form) { build(:start_form) }

    start_options = %w[new
                       reregister
                       edit].freeze

    it "validates the start option using the StartValidator class" do
      validators = form._validators
      aggregate_failures do
        expect(validators[:start_option].first.class)
          .to eq(WasteExemptionsEngine::StartValidator)
      end
    end

    it_behaves_like "a validated form", :start_form do
      let(:valid_params) { { start_option: start_options.sample } }
      let(:invalid_params) do
        [
          { start_option: "foo" },
          { start_option: "" }
        ]
      end
    end

    describe "#submit" do
      context "when the form is valid" do
        it "updates the transient registration with the selected start option" do
          start_option = start_options.sample
          valid_params = { start_option: start_option }
          transient_registration = form.transient_registration

          aggregate_failures do
            expect(transient_registration.start_option).to be_blank
            form.submit(valid_params)
            expect(transient_registration.start_option).to eq(start_option)
          end
        end
      end
    end
  end
end
