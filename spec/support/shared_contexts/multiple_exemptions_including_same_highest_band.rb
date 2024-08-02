# frozen_string_literal: true

RSpec.shared_context "with multiple exemptions including same highest band" do
  let(:highest_charge_band) do
    create(:band,
           initial_compliance_charge: create(:charge, charge_amount: 40_900),
           additional_compliance_charge: create(:charge, charge_amount: 7400))
  end

  let(:middle_charge_band) do
    create(:band,
           initial_compliance_charge: create(:charge, charge_amount: 30_000),
           additional_compliance_charge: create(:charge, charge_amount: 7400))
  end

  let(:lowest_charge_band) do
    create(:band,
           initial_compliance_charge: create(:charge, charge_amount: 15_000),
           additional_compliance_charge: create(:charge, charge_amount: 3000))
  end

  let(:exemptions) do
    [
      create(:exemption, code: "T10", band: highest_charge_band),
      create(:exemption, code: "T12", band: highest_charge_band),
      create(:exemption, code: "T16", band: middle_charge_band),
      create(:exemption, code: "T28", band: lowest_charge_band)
    ]
  end

  let(:order) { create(:order, exemptions: exemptions) }
end
