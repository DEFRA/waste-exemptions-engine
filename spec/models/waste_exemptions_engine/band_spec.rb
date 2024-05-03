# frozen_string_literal: true

require "rails_helper"
require "./spec/models/waste_exemptions_engine/concerns/can_convert_pence_to_pounds_spec"

module WasteExemptionsEngine
  RSpec.describe Band do
    describe "public interface" do
      subject(:band) { build(:band) }

      Helpers::ModelProperties::BAND.each do |property|
        it "responds to property" do
          expect(band).to respond_to(property)
        end
      end

      context "when the band has CanConvertPenceToPounds concern included" do
        it_behaves_like "can_convert_pence_to_pounds", "band", :initial_compliance_charge
        it_behaves_like "can_convert_pence_to_pounds", "band", :additional_compliance_charge
      end
    end
  end
end
