# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe EditHelper do
    describe "exemptions_list" do
      let(:result) { helper.exemptions_list(edit_registration) }
      let(:edit_registration) { create(:front_office_edit_registration) }

      before { helper.instance_variable_set(:@virtual_path, "waste_exemptions_engine.front_office_edit_forms.new") }

      it "includes the code for each of the transient registration's exemptions" do
        expect(result.split(", "))
          .to match_array(edit_registration.exemptions.pluck(:code))
      end
    end
  end
end
