# frozen_string_literal: true

RSpec.shared_context "with bands and charges" do
  let!(:registration_charge_entity) { create(:charge, :registration_charge) }
  let(:registration_charge_amount) { registration_charge_entity.charge_amount }

  # rubocop:disable RSpec/IndexedLet,RSpec/LetSetup
  let!(:band_1) do
    create(:band,
           initial_compliance_charge: build(:charge, :initial_compliance_charge, charge_amount: 5),
           additional_compliance_charge: build(:charge, :additional_compliance_charge, charge_amount: 4))
  end
  let!(:band_2) do
    create(:band,
           initial_compliance_charge: build(:charge, :initial_compliance_charge, charge_amount: 7),
           additional_compliance_charge: build(:charge, :additional_compliance_charge, charge_amount: 5))
  end
  let!(:band_3) do
    create(:band,
           initial_compliance_charge: build(:charge, :initial_compliance_charge, charge_amount: 10),
           additional_compliance_charge: build(:charge, :additional_compliance_charge, charge_amount: 7))
  end
  # rubocop:enable RSpec/IndexedLet,RSpec/LetSetup
end
