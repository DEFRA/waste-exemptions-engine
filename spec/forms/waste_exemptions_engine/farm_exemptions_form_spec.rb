# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe FarmExemptionsForm, type: :model do
    before { create_list(:exemption, 5) }

    subject(:form) { build(:farm_exemptions_form) }
    let(:transient_registration) { form.transient_registration }
    let(:farm_registration) { true }

    let(:three_exemptions) { Exemption.order("RANDOM()").last(3) }
    let(:two_activity_exemptions) { Exemption.order("RANDOM()").first(2) }

    before do
      transient_registration.on_a_farm = farm_registration
      transient_registration.is_a_farmer = farm_registration
      transient_registration.temp_add_additional_non_farm_exemptions = farm_registration
      transient_registration.save
    end

    it_behaves_like "a validated form", :farm_exemptions_form do
      let(:valid_params) { { temp_exemptions: three_exemptions.map(&:id).map(&:to_s) } }
    end

    describe "#submit" do
      context "when the form is valid" do
        context "when no exemptions have been selected" do
          let(:valid_params) { { temp_exemptions: [] } }

          it { expect(form.valid?).to be true }

          it "clears farm exemptions but preserves activity exemptions" do
            transient_registration = form.transient_registration
            activity_exemptions = two_activity_exemptions.map(&:id).map(&:to_s)
            transient_registration.temp_activity_exemptions = activity_exemptions

            form.submit(valid_params)

            aggregate_failures do
              expect(transient_registration.temp_farm_exemptions).to be_empty
              expect(transient_registration.temp_activity_exemptions).to match_array(activity_exemptions)
              expect(transient_registration.temp_exemptions).to match_array(activity_exemptions)
            end
          end
        end

        context "when farm exemptions have been selected" do
          let(:farm_exemptions) { three_exemptions.map(&:id).map(&:to_s) }
          let(:activity_exemptions) { two_activity_exemptions.map(&:id).map(&:to_s) }
          let(:valid_params) { { temp_exemptions: farm_exemptions } }

          context "when the registration is farm affiliated and can add additional exemptions" do
            let(:farm_registration) { true }
            before do
              transient_registration.temp_activity_exemptions = activity_exemptions
            end

            it "updates temp_farm_exemptions and combines with existing activity exemptions" do
              form.submit(valid_params)

              aggregate_failures do
                expect(transient_registration.temp_farm_exemptions).to match_array(farm_exemptions)
                expect(transient_registration.temp_activity_exemptions).to match_array(activity_exemptions)
                expect(transient_registration.temp_exemptions).to match_array((activity_exemptions + farm_exemptions).uniq)
              end
            end
          end

          context "when the registration is not farm affiliated" do
            let(:farm_registration) { false }
            before do
              transient_registration.temp_activity_exemptions = activity_exemptions
            end

            it "updates temp_farm_exemptions but keeps only activity exemptions" do
              form.submit(valid_params)

              aggregate_failures do
                expect(transient_registration.temp_farm_exemptions).to match_array(farm_exemptions)
                expect(transient_registration.temp_activity_exemptions).to match_array(activity_exemptions)
                expect(transient_registration.temp_exemptions).to match_array(activity_exemptions)
              end
            end
          end
        end
      end
    end
  end
end
