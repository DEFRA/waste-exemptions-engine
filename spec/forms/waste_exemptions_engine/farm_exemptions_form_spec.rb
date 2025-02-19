# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe FarmExemptionsForm, type: :model do
    before do
      create_list(:exemption, 5)
      transient_registration.on_a_farm = true
      transient_registration.is_a_farmer = true
      transient_registration.temp_add_additional_non_bucket_exemptions = add_additional_non_farm_exemptions
      transient_registration.save
    end

    subject(:form) { build(:farm_exemptions_form) }
    let(:transient_registration) { form.transient_registration }
    let(:add_additional_non_farm_exemptions) { true }

    let(:three_exemptions) { Exemption.order("RANDOM()").last(3) }
    let(:two_activity_exemptions) { Exemption.order("RANDOM()").first(2) }

    it_behaves_like "a validated form", :farm_exemptions_form do
      let(:valid_params) { { temp_exemptions: three_exemptions.map(&:id).map(&:to_s) } }
      let(:invalid_params) { { temp_exemptions: [] } }
    end

    describe "#submit" do
      context "when the form is valid" do
        context "when no exemptions have been selected" do
          let(:valid_params) { { temp_exemptions: [] } }

          it { expect(form.valid?).to be false }

          it "fails to submit" do
            expect(form.submit(valid_params)).to be(false)
          end
        end

        context "when farm exemptions have been selected" do
          let(:farmer_bucket) { create(:bucket, bucket_type: "farmer") }
          let(:farm_exemptions) { three_exemptions.map(&:id).map(&:to_s) }
          let(:activity_exemptions) { two_activity_exemptions.map(&:id).map(&:to_s) }
          let(:valid_params) { { temp_exemptions: farm_exemptions } }

          before do
            # Associate farm exemptions with farmer bucket
            three_exemptions.each { |exemption| create(:bucket_exemption, bucket: farmer_bucket, exemption: exemption) }
          end

          it "updates the transient registration with the selected farm exemptions" do
            form.submit(valid_params)

            expect(transient_registration.temp_exemptions).to match_array(farm_exemptions)
          end

          context "when the user has added non-farm exemptions already" do
            before do
              transient_registration.temp_exemptions = activity_exemptions
            end

            it "combines with existing activity exemptions" do
              form.submit(valid_params)

              expect(transient_registration.temp_exemptions).to match_array((activity_exemptions + farm_exemptions).uniq.sort)
            end
          end
        end
      end
    end
  end
end
