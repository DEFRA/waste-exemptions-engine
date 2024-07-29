# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe CreateOrUpdateOrderService do
    subject(:service) { described_class.new }

    let(:transient_registration) { create(:new_charged_registration) }
    let(:order) { create(:order) }
    let(:exemption) { create(:exemption) }
    let(:exemption2) { create(:exemption) }
    let(:farmer_bucket) { create(:bucket, bucket_type: "farmer") }

    describe "#run" do
      before do
        allow(transient_registration).to receive(:order).and_return(order)
        allow(WasteExemptionsEngine::Bucket).to receive(:find_by).and_return(farmer_bucket)
      end

      it "assigns exemptions to the order" do
        allow(transient_registration).to receive(:exemptions).and_return([exemption])
        expect { service.run(transient_registration: transient_registration) }
          .to change { order.order_exemptions.count }.from(0).to(1)
      end

      it "assigns the farmer bucket when applicable" do
        allow(transient_registration).to receive_messages(exemptions: [], farm_affiliated?: true)
        allow(order).to receive(:create_order_bucket!)

        service.run(transient_registration: transient_registration)

        expect(order).to have_received(:create_order_bucket!).with(bucket: farmer_bucket)
      end

      it "does not assign a bucket when not farm affiliated" do
        allow(transient_registration).to receive_messages(exemptions: [], farm_affiliated?: false)
        allow(order).to receive(:create_order_bucket!)

        service.run(transient_registration: transient_registration)

        expect(order).not_to have_received(:create_order_bucket!)
      end

      it "returns the order" do
        allow(transient_registration).to receive(:exemptions).and_return([])
        expect(service.run(transient_registration: transient_registration)).to eq(order)
      end

      context "when the transient registration already has an order" do
        before do
          allow(transient_registration).to receive(:order).and_return(order)
        end

        it "updates the order with new exemptions" do
          allow(transient_registration).to receive(:exemptions).and_return([exemption, exemption2])
          expect do
            service.run(transient_registration: transient_registration)
          end.to change { order.order_exemptions.count }.from(0).to(2)
        end

        it "removes exemptions that are no longer associated" do
          order.order_exemptions.create!(exemption: exemption)
          allow(transient_registration).to receive(:exemptions).and_return([exemption2])

          service.run(transient_registration: transient_registration)

          expect(order.exemptions).to contain_exactly(exemption2)
        end
      end

      context "when farmer bucket does not exist" do
        before do
          allow(transient_registration).to receive(:farm_affiliated?).and_return(true)
          allow(WasteExemptionsEngine::Bucket).to receive(:find_by).and_return(nil)
          allow(order).to receive(:create_order_bucket!)
        end

        it "does not create an order bucket" do
          allow(transient_registration).to receive(:exemptions).and_return([])
          service.run(transient_registration: transient_registration)
          expect(order).not_to have_received(:create_order_bucket!)
        end
      end
    end
  end
end
