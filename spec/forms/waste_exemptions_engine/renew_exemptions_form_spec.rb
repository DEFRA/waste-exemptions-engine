# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe RenewExemptionsForm, type: :model do
    before do
      create_list(:exemption, 5)
    end

    subject(:form) { build(:exemptions_form) }

    let(:three_exemptions) { Exemption.order("RANDOM()").last(3) }

    describe "#submit" do
      it "updates the transient registration with the selected exemptions" do
        exemption_codes = three_exemptions.map(&:code)
        exemption_id_strings = three_exemptions.map(&:id).map(&:to_s)
        valid_params = { exemption_ids: exemption_id_strings }
        transient_registration = form.transient_registration

        expect(transient_registration.exemptions).to be_empty
        form.submit(valid_params)
        expect(transient_registration.exemptions.map(&:code)).to match_array(exemption_codes)
      end

      it "updates the transient registration with no selected exemptions" do
        transient_registration = form.transient_registration

        expect(transient_registration.exemptions).to be_empty
        form.submit({})
        expect(transient_registration.exemptions).to match_array([])
      end
    end
  end
end
