# frozen_string_literal: true

RSpec.shared_context "for charging scenarios" do

  subject(:charge_details) { described_class.new(order).charge_detail }

  registration_charge_pounds = 41
  farmers_bucket_charge_pounds = 90
  band_costs_pounds = {
    upper: [1_180, 221],
    u1: [409, 74],
    u2: [207, 74],
    u3: [30, 30]
  }

  let(:registration_charge_amount) { 100 * registration_charge_pounds }
  let(:farmers_bucket_charge_amount) { 100 * farmers_bucket_charge_pounds }
  let(:band_costs_pence) { band_costs_pounds.transform_values { |v| [v[0] * 100, v[1] * 100] } }

  let(:band_charges) { charge_details.band_charge_details }
  let(:order) { create(:order, exemptions:) }

  before { create(:charge, :registration_charge, charge_amount: registration_charge_amount) }

  # bands
  band_costs_pounds.each do |level, costs|
    let("band_#{level}") do
      create(:band,
             name: "band_#{level}",
             initial_compliance_charge: build(:charge, :initial_compliance_charge, charge_amount: 100 * costs[0]),
             additional_compliance_charge: build(:charge, :additional_compliance_charge,
                                                 charge_amount: 100 * costs[1]))
    end
    let("band_charges_#{level}") { band_charges.select { |bc| bc.band.name == "band_#{level}" }.first }
  end

  # exemptions
  %i[U16 T8 T9].each do |ex|
    let("exemption_#{ex}") { create(:exemption, code: ex, band: band_upper) }
  end

  %i[U1 U9 T4 T5 T6 T10 T12 T21 T24 T25 S1 S2].each do |ex|
    let("exemption_#{ex}") { create(:exemption, code: ex, band: band_u1) }
  end

  %i[U2 U4 U8 U10 U11 T1 T2 T13 T14 T15 T16 T17 T19 T23 T30 T31 T33 S3 D1 D6].each do |ex|
    let("exemption_#{ex}") { create(:exemption, code: ex, band: band_u2) }
  end

  %i[U3 U5 U6 U7 U12 U13 U14 U15 T18 T20 T26 T28 T29 T32 D2 D3 D4 D5 D7 D8].each do |ex|
    let("exemption_#{ex}") { create(:exemption, code: ex, band: band_u3) }
  end

end
