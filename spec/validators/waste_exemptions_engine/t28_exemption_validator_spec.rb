# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe T28ExemptionValidator do
    subject(:validator) { described_class.new(attributes: [:temp_exemptions]) }

    let(:t28_exemption) { create(:exemption, code: "T28") }
    let(:t1_exemption) { create(:exemption, code: "T1") }
    let(:transient_registration) { create(:new_registration) }
    let(:form) { ActivityExemptionsForm.new(transient_registration) }

    context "when a T28 exemption is selected in the front office" do
      before do
        allow(WasteExemptionsEngine.configuration).to receive(:host_is_back_office?).and_return(false)
        transient_registration.temp_exemptions = [t28_exemption.id.to_s]
        validator.validate_each(form, :temp_exemptions, transient_registration.temp_exemptions)
      end

      it "adds an error to the form" do
        expect(form.errors[:temp_exemptions]).to include(I18n.t("activemodel.errors.models.waste_exemptions_engine/activity_exemptions_form.attributes.temp_exemptions.t28_exemption_selected"))
      end
    end

    context "when a T28 exemption is not selected" do
      before do
        transient_registration.temp_exemptions = [t1_exemption.id.to_s]
        validator.validate_each(form, :temp_exemptions, transient_registration.temp_exemptions)
      end

      it "does not add an error to the form" do
        expect(form.errors[:temp_exemptions]).to be_empty
      end
    end

    context "when in back office" do
      before do
        allow(WasteExemptionsEngine.configuration).to receive(:host_is_back_office?).and_return(true)
        transient_registration.temp_exemptions = [t28_exemption.id.to_s]
        validator.validate_each(form, :temp_exemptions, transient_registration.temp_exemptions)
      end

      it "does not add an error to the form" do
        expect(form.errors[:temp_exemptions]).to be_empty
      end
    end
  end
end
