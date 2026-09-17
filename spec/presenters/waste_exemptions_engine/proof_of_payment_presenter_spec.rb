# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe ProofOfPaymentPresenter do
    subject(:personalisation) { described_class.new(registration:).personalisation }

    let(:registration) do
      instance_double(Registration,
                      reference: "WEX123456",
                      contact_first_name: "Jo",
                      contact_last_name: "Bloggs",
                      submitted_at: Date.new(2026, 9, 1),
                      account:)
    end
    let(:account) { instance_double(Account, payments: [payment], orders: [order]) }
    let(:order) do
      instance_double(Order,
                      id: 1,
                      exemptions:,
                      bucket:,
                      charge_detail:)
    end
    let(:exemptions) { [exemption] }
    let(:bucket) { nil }
    let(:payment) do
      instance_double(Payment,
                      success?: true,
                      payment_type: Payment::PAYMENT_TYPE_GOVPAY,
                      payment_amount: 49_500,
                      date_time: Time.zone.local(2026, 9, 2, 12),
                      created_at: Time.zone.local(2026, 9, 2, 12),
                      id: 1)
    end
    let(:exemption) do
      instance_double(Exemption,
                      code: "U1",
                      summary: "using waste in construction",
                      band_id: 1)
    end
    let(:band_charge_detail) do
      instance_double(BandChargeDetail,
                      band_id: 1,
                      initial_compliance_charge_amount: 43_596,
                      additional_compliance_charge_amount: 0)
    end
    let(:charge_detail) do
      instance_double(ChargeDetail,
                      registration_charge_amount: 5904,
                      bucket_charge_amount: 0,
                      band_charge_details: [band_charge_detail])
    end
    let(:expected_breakdown) do
      "* U1 Using waste in construction: £435.96\n" \
        "* Registration charge: £59.04\n" \
        "* VAT exempt: £0"
    end

    def expected_personalisation
      {
        reg_identifier: "WEX123456",
        first_name: "Jo",
        last_name: "Bloggs",
        date_registered: "1 September 2026",
        date_paid: "2 September 2026",
        payment_method: "Card",
        payment_amount: "495.00",
        exemption_breakdown: expected_breakdown
      }
    end

    it "provides the Notify template values" do
      expect(personalisation).to eq(expected_personalisation)
    end

    context "with a BACS payment" do
      before do
        allow(payment).to receive(:payment_type).and_return(Payment::PAYMENT_TYPE_BANK_TRANSFER)
      end

      it "labels the payment method as BACS" do
        expect(personalisation[:payment_method]).to eq("BACS")
      end
    end

    context "with multiple exemptions in the same band" do
      let(:exemptions) do
        [
          exemption,
          instance_double(Exemption,
                          code: "U10",
                          summary: "spreading waste to benefit agricultural land",
                          band_id: 1)
        ]
      end
      let(:band_charge_detail) do
        instance_double(BandChargeDetail,
                        band_id: 1,
                        initial_compliance_charge_amount: 43_596,
                        additional_compliance_charge_amount: 7889)
      end
      let(:expected_breakdown) do
        "* U1 Using waste in construction: £435.96\n" \
          "* U10 Spreading waste to benefit agricultural land: £78.89\n" \
          "* Registration charge: £59.04\n" \
          "* VAT exempt: £0"
      end

      it "uses the stored initial and additional charges" do
        expect(personalisation[:exemption_breakdown]).to eq(expected_breakdown)
      end
    end

    context "with farming exemptions" do
      let(:bucket) { instance_double(Bucket, exemptions:) }
      let(:charge_detail) do
        instance_double(ChargeDetail,
                        registration_charge_amount: 5904,
                        bucket_charge_amount: 31_114,
                        band_charge_details: [band_charge_detail])
      end
      let(:expected_breakdown) do
        "* Farming exemptions (U1): £311.14\n" \
          "* Registration charge: £59.04\n" \
          "* VAT exempt: £0"
      end

      it "shows the stored bucket charge once" do
        expect(personalisation[:exemption_breakdown]).to eq(expected_breakdown)
      end
    end
  end
end
