# frozen_string_literal: true

require "rails_helper"

RSpec.describe "T28 exemption validation" do
  let(:t28_exemption) { create(:exemption, code: "T28") }
  let(:t1_exemption) { create(:exemption, code: "T1") }

  before do
    # Ensure we're in front office mode for these tests
    allow(WasteExemptionsEngine.configuration).to receive(:host_is_back_office?).and_return(false)
  end

  context "when in a non-farming journey" do
    let(:new_registration) { create(:new_registration) }
    let(:activity_exemptions_form) { build(:activity_exemptions_form, transient_registration: new_registration) }

    it "is invalid when T28 is selected" do
      # Set up the form with T28 selected
      new_registration.temp_exemptions = [t28_exemption.id.to_s]

      # Validate the form
      expect(activity_exemptions_form.valid?).to be(false)
    end

    it "shows T28 validation error when T28 is selected" do
      # Set up the form with T28 selected
      new_registration.temp_exemptions = [t28_exemption.id.to_s]

      # Validate the form
      activity_exemptions_form.valid?
      expect(activity_exemptions_form.errors[:temp_exemptions]).to include(
        I18n.t("activemodel.errors.models.waste_exemptions_engine/activity_exemptions_form.attributes.temp_exemptions.t28_exemption_selected")
      )
    end

    it "passes validation when T28 is not selected" do
      # Set up the form with a different exemption
      new_registration.temp_exemptions = [t1_exemption.id.to_s]

      # Validate the form - should pass T28 validation but might fail other validations
      expect(activity_exemptions_form.errors[:temp_exemptions]).not_to include(
        I18n.t("activemodel.errors.models.waste_exemptions_engine/activity_exemptions_form.attributes.temp_exemptions.t28_exemption_selected")
      )
    end
  end

  context "when in a farming journey" do
    let(:new_registration) { create(:new_registration, on_a_farm: true, is_a_farmer: true) }
    let(:farm_exemptions_form) { build(:farm_exemptions_form, transient_registration: new_registration) }

    it "is invalid when T28 is selected" do
      # Set up the form with T28 selected
      new_registration.temp_exemptions = [t28_exemption.id.to_s]

      # Validate the form
      expect(farm_exemptions_form.valid?).to be(false)
    end

    it "shows T28 validation error when T28 is selected" do
      # Set up the form with T28 selected
      new_registration.temp_exemptions = [t28_exemption.id.to_s]

      # Validate the form
      farm_exemptions_form.valid?
      expect(farm_exemptions_form.errors[:temp_exemptions]).to include(
        I18n.t("activemodel.errors.models.waste_exemptions_engine/farm_exemptions_form.attributes.temp_exemptions.t28_exemption_selected")
      )
    end

    it "passes validation when T28 is not selected" do
      # Set up the form with a different exemption
      new_registration.temp_exemptions = [t1_exemption.id.to_s]

      # Validate the form - should pass T28 validation but might fail other validations
      expect(farm_exemptions_form.errors[:temp_exemptions]).not_to include(
        I18n.t("activemodel.errors.models.waste_exemptions_engine/farm_exemptions_form.attributes.temp_exemptions.t28_exemption_selected")
      )
    end
  end

  context "when in back office" do
    before do
      allow(WasteExemptionsEngine.configuration).to receive(:host_is_back_office?).and_return(true)
    end

    let(:new_registration) { create(:new_registration) }
    let(:activity_exemptions_form) { build(:activity_exemptions_form, transient_registration: new_registration) }

    it "passes validation even when T28 is selected" do
      # Set up the form with T28 selected
      new_registration.temp_exemptions = [t28_exemption.id.to_s]

      # Validate the form - should not have T28 error in back office
      expect(activity_exemptions_form.errors[:temp_exemptions]).not_to include(
        I18n.t("activemodel.errors.models.waste_exemptions_engine/activity_exemptions_form.attributes.temp_exemptions.t28_exemption_selected")
      )
    end
  end
end
