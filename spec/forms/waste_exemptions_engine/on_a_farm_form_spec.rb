# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe OnAFarmForm, type: :model do
    subject(:form) { build(:on_a_farm_form) }

    it "validates the on a farm question using the YesNoValidator class" do
      validators = form._validators
      aggregate_failures do
        expect(validators[:on_a_farm].first.class)
          .to eq(DefraRuby::Validators::TrueFalseValidator)
      end
    end

    it_behaves_like "a validated form", :on_a_farm_form do
      let(:valid_params) do
        [
          { on_a_farm: "true" },
          { on_a_farm: "false" }
        ]
      end
      let(:invalid_params) do
        [
          { on_a_farm: "" }
        ]
      end
    end

    describe "#submit" do
      context "when the form is valid" do
        it "updates the transient registration with the on a farm answer" do
          on_a_farm = true
          valid_params = { on_a_farm: on_a_farm }
          transient_registration = form.transient_registration

          aggregate_failures do
            expect(transient_registration.on_a_farm).to be_blank
            form.submit(valid_params)
            expect(transient_registration.reload.on_a_farm).to be_truthy
          end
        end
      end

      context "when the on a farm answer changes to false" do
        let(:transient_registration) { form.transient_registration }
        let(:farmer_bucket) { create(:bucket, bucket_type: "farmer") }

        before do
          transient_registration.update(on_a_farm: true, order: build(:order, bucket: farmer_bucket))
        end

        it "deletes the farmer bucket" do
          expect { form.submit(on_a_farm: "false") }.to change { transient_registration.reload.order.bucket }.to(nil)
        end
      end
    end
  end
end
