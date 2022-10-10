# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe CheckContactNameForm, type: :model do
    it_behaves_like "a validated form", :check_contact_name_form do
      let(:valid_params) do
        [
          { temp_reuse_applicant_name: "true" },
          { temp_reuse_applicant_name: "false" }
        ]
      end
      let(:invalid_params) do
        [
          { temp_reuse_applicant_name: "" }
        ]
      end
    end

    describe "#submit" do
      let(:form) { build(:check_contact_name_form) }

      subject(:submit_form) { form.submit(temp_reuse_applicant_name: temp_reuse_applicant_name) }

      context "when temp_reuse_applicant_name is true" do
        let(:temp_reuse_applicant_name) { "true" }

        it "assigns the applicant name as the contact name" do
          submit_form

          expect(form.contact_first_name).to eq(form.applicant_first_name)
          expect(form.contact_last_name).to eq(form.applicant_last_name)
        end
      end

      context "when temp_reuse_applicant_name is false" do
        let(:temp_reuse_applicant_name) { "false" }

        it "does not assign the contact name" do
          submit_form

          expect(form.transient_registration.contact_first_name).to be_blank
          expect(form.transient_registration.contact_last_name).to be_blank
        end
      end

      context "when temp_reuse_applicant_name is blank" do
        let(:temp_reuse_applicant_name) { nil }

        it "raises an error" do
          submit_form

          expect(form.errors[:temp_reuse_applicant_name]).to be_present
        end
      end
    end
  end
end
