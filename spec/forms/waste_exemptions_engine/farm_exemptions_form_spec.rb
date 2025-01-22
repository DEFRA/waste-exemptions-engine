# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe FarmExemptionsForm, type: :model do
    before { create_list(:exemption, 5) }

    subject(:form) { build(:farm_exemptions_form) }

    let(:three_exemptions) { Exemption.order("RANDOM()").last(3) }

    it_behaves_like "a validated form", :activity_exemptions_form do
      let(:valid_params) { { temp_exemptions: three_exemptions.map(&:id).map(&:to_s) } }
    end

    describe "#submit" do
      context "when the form is valid" do
        context "when no exemptions have been selected" do
          let(:valid_params) { { temp_exemptions: [] } }

          it { expect(form.valid?).to be true }
        end

        context "when exemptions have been selected" do
          let(:activity_exemptions_id_strings) { three_exemptions.map(&:id).map(&:to_s) }
          let(:valid_params) { { temp_exemptions: activity_exemptions_id_strings } }

          it "updates the transient registration with the selected activity exemptions" do
            transient_registration = form.transient_registration

            aggregate_failures do
              expect(transient_registration.temp_exemptions).to be_empty
              form.submit(valid_params)
              expect(transient_registration.temp_exemptions).to match_array(activity_exemptions_id_strings)
            end
          end
        end
      end
    end
  end
end
