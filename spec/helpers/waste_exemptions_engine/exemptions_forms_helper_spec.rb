# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe ExemptionsFormsHelper do
    describe "#all_exemptions" do
      it "returns a list of all exemptions ordered by ID" do
        # FIXME: There are still tests leaving the DB dirty with exemptions.
        # This line will prevent random failure of this scenario
        WasteExemptionsEngine::Exemption.delete_all

        exemptions = create_list(:exemption, 3)
        expect(helper.all_exemptions).to eq(exemptions)
      end
    end

    describe "#all_visible_exemptions" do
      it "returns a list of visible (not hidden) exemptions ordered by ID" do
        exemptions = create_list(:exemption, 3)
        exemptions.first.update(hidden: true)

        expect(helper.all_visible_exemptions.count).to eq(exemptions.count - 1)
      end
    end
  end
end
