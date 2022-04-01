# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe CheckContactEmailForm, type: :model do
    it_behaves_like "a validated form", :check_contact_email_form do
      let(:valid_params) do
        [
          { temp_reuse_applicant_email: "true" },
          { temp_reuse_applicant_email: "false" }
        ]
      end
      let(:invalid_params) do
        [
          { temp_reuse_applicant_email: "" }
        ]
      end
    end

    describe "#submit" do
      let(:form) { build(:check_contact_email_form) }

      subject do
        form.submit(temp_reuse_applicant_email: temp_reuse_applicant_email)
      end

      context "when temp_reuse_applicant_email is true" do
        let(:temp_reuse_applicant_email) { "true" }

        it "assigns the applicant_email as the contact_email" do
          subject

          expect(form.contact_email).to eq(form.applicant_email)
        end
      end

      context "when temp_reuse_applicant_email is false" do
        let(:temp_reuse_applicant_email) { "false" }

        it "does not assign the contact_email" do
          subject

          expect(form.transient_registration.contact_email).to be_blank
        end
      end
    end
  end
end
