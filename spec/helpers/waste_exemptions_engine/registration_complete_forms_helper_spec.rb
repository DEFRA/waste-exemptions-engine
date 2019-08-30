# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe RegistrationCompleteFormsHelper, type: :helper do
    describe "#exemptions_plural" do
      let(:form) { double(:form, exemptions: exemptions) }

      context "when there is more than one exemption" do
        let(:exemptions) { %i[exemption_1 exemption_2] }

        it "returns the string `many`" do
          expect(helper.exemptions_plural(form)).to eq("many")
        end
      end

      context "when there is only one exemption" do
        let(:exemptions) { [:exemption] }

        it "returns the string `one`" do
          expect(helper.exemptions_plural(form)).to eq("one")
        end
      end
    end
  end
end
