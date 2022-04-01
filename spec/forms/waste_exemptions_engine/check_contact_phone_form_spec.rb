# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe CheckContactPhoneForm, type: :model do
    it_behaves_like "a validated form", :check_contact_phone_form do
      let(:valid_params) do
        [
          { temp_reuse_applicant_phone: "true" },
          { temp_reuse_applicant_phone: "false" }
        ]
      end
      let(:invalid_params) do
        [
          { temp_reuse_applicant_phone: "" }
        ]
      end
    end

    describe "#submit" do
      let(:form) { build(:check_contact_phone_form) }

      subject do
        form.submit(temp_reuse_applicant_phone: temp_reuse_applicant_phone)
      end

      context "when temp_reuse_applicant_phone is true" do
        let(:temp_reuse_applicant_phone) { "true" }

        it "assigns the applicant_phone as the contact_phone" do
          subject

          expect(form.contact_phone).to eq(form.applicant_phone)
        end
      end

      context "when temp_reuse_applicant_phone is false" do
        let(:temp_reuse_applicant_phone) { "false" }

        it "does not assign the contact_phone" do
          subject

          expect(form.transient_registration.contact_phone).to be_blank
        end
      end
    end
  end
end
