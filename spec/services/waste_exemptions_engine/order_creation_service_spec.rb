# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe OrderCreationService do
    subject(:service) { described_class.new }

    let(:transient_registration) { create(:new_registration) }
    let(:order) { create(:order) }
    let(:exemption) { create(:exemption) }
    let(:transient_registration_exemption) { create(:transient_registration_exemption, exemption: exemption) }

    describe "#run" do
      before do
        allow(transient_registration).to receive_messages(create_order: order, transient_registration_exemptions: [transient_registration_exemption])
        allow(service).to receive(:assign_bucket)
      end

      it "creates an order for the transient registration" do
        service.run(transient_registration: transient_registration)
        expect(transient_registration).to have_received(:create_order)
      end

      it "assigns exemptions to the order" do
        expect do
          service.run(transient_registration: transient_registration)
        end.to change(order.order_exemptions, :count).by(1)
      end

      it "calls assign_bucket" do
        service.run(transient_registration: transient_registration)
        expect(service).to have_received(:assign_bucket)
      end

      it "returns the created order" do
        expect(service.run(transient_registration: transient_registration)).to eq(order)
      end
    end

    describe "#assign_exemptions" do
      before do
        allow(transient_registration).to receive(:transient_registration_exemptions).and_return([transient_registration_exemption])
        service.instance_variable_set(:@transient_registration, transient_registration)
        service.instance_variable_set(:@order, order)
      end

      it "creates order_exemptions for each transient_registration_exemption" do
        expect do
          service.assign_exemptions
        end.to change(order.order_exemptions, :count).by(1)
      end
    end

    describe "#assign_bucket" do
      let(:farmer_bucket) { create(:bucket, name: "Farmer Bucket") }

      before do
        service.instance_variable_set(:@transient_registration, transient_registration)
        service.instance_variable_set(:@order, order)
        allow(service).to receive(:farmer_bucket).and_return(farmer_bucket)
      end

      context "when the registration is farm affiliated and farmer bucket exists" do
        before do
          allow(transient_registration).to receive(:farm_affiliated?).and_return(true)
          allow(order).to receive(:create_order_bucket!)
          service.assign_bucket
        end

        it "creates an order bucket" do
          expect(order).to have_received(:create_order_bucket!).with(bucket: farmer_bucket)
        end
      end

      context "when the registration is not farm affiliated" do
        before do
          allow(transient_registration).to receive(:farm_affiliated?).and_return(false)
          allow(order).to receive(:create_order_bucket!)
          service.assign_bucket
        end

        it "does not create an order bucket" do
          expect(order).not_to have_received(:create_order_bucket!)
        end
      end

      context "when farmer bucket does not exist" do
        before do
          allow(transient_registration).to receive(:farm_affiliated?).and_return(true)
          allow(service).to receive(:farmer_bucket).and_return(nil)
          allow(order).to receive(:create_order_bucket!)
          service.assign_bucket
        end

        it "does not create an order bucket" do
          expect(order).not_to have_received(:create_order_bucket!)
        end
      end
    end

    describe "#farmer_bucket" do
      let(:bucket_name) { "Farmer Bucket" }
      let(:farmer_bucket) { build(:bucket) }

      before do
        allow(I18n).to receive(:t).with("waste_exemptions_engine.farmer_bucket", locale: :en).and_return(bucket_name)
        allow(WasteExemptionsEngine::Bucket).to receive(:find_by).and_return(farmer_bucket)
      end

      it "finds the farmer bucket by name" do
        service.farmer_bucket
        expect(WasteExemptionsEngine::Bucket).to have_received(:find_by).with(name: bucket_name)
      end

      it "memoizes the result" do
        2.times { service.farmer_bucket }
        expect(WasteExemptionsEngine::Bucket).to have_received(:find_by).once
      end
    end
  end
end
