# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe EditExemptionsForm, type: :model do
    before do
      create_list(:exemption, 5)
    end

    subject(:form) { build(:edit_exemptions_form) }

    let(:three_exemptions) { Exemption.order("RANDOM()").last(3) }

    describe "#submit" do
      before do
        form.exemptions.delete_all
      end

      it "updates the transient registration with the selected exemptions" do
        exemption_codes = three_exemptions.map(&:code)
        exemption_id_strings = three_exemptions.map(&:id).map(&:to_s)
        valid_params = { exemption_ids: exemption_id_strings }
        transient_registration = form.transient_registration

        aggregate_failures do
          expect(transient_registration.exemptions).to be_empty
          form.submit(valid_params)
          expect(transient_registration.exemptions.map(&:code)).to match_array(exemption_codes)
        end
      end

      it "updates the transient registration with no selected exemptions" do
        transient_registration = form.transient_registration
        expect { form.submit({}) }.not_to change(transient_registration, :exemptions).from([])
      end
    end
  end
end
