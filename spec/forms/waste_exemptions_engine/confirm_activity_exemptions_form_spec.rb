# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe ConfirmActivityExemptionsForm, type: :model do
    let(:three_exemption_ids) { Exemption.order("RANDOM()").last(3) }

    subject(:form) { build(:confirm_activity_exemptions_form) }

    it "validates the matched exemptions using the ExemptionsValidator class" do
      validators = form._validators
      expect(validators[:temp_confirm_exemptions].first.class)
        .to eq(ActiveModel::Validations::InclusionValidator)
    end

    it_behaves_like "a validated form", :confirm_activity_exemptions_form do
      let(:valid_params) { { temp_confirm_exemptions: "true" } }
      let(:invalid_params) { { temp_confirm_exemptions: nil } }
    end

    describe "#submit" do
      before do
        form.transient_registration.update(temp_exemptions: three_exemption_ids)
      end

      context "when the form is valid" do
        it "sets temp_confirm_exemptions" do
          valid_params = { temp_confirm_exemptions: "true" }
          transient_registration = form.transient_registration

          aggregate_failures do
            expect(form.temp_confirm_exemptions).to be_nil
            form.submit(valid_params)
            expect(form.temp_confirm_exemptions).to eq(valid_params[:temp_confirm_exemptions])
            expect(transient_registration.exemptions.map(&:id)).to match_array(three_exemption_ids)
          end
        end
      end
    end
  end
end
