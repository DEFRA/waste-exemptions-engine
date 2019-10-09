# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe ContactNameForm, type: :model do
    subject(:form) { build(:contact_name_form) }

    describe "validations" do
      subject(:validators) { form._validators }

      it "validates the first name using the PersonNameValidator class" do
        expect(validators.keys).to include(:contact_first_name)
        expect(validators[:contact_first_name].first.class)
          .to eq(WasteExemptionsEngine::PersonNameValidator)
      end

      it "validates the last name using the PersonNameValidator class" do
        expect(validators.keys).to include(:contact_last_name)
        expect(validators[:contact_first_name].first.class)
          .to eq(WasteExemptionsEngine::PersonNameValidator)
      end
    end

    it_behaves_like "a validated form", :contact_name_form do
      let(:valid_params) do
        { contact_first_name: "Joe", contact_last_name: "Bloggs" }
      end
      let(:invalid_params) do
        [
          { contact_first_name: "", contact_last_name: "Bloggs" },
          { contact_first_name: "Joe", contact_last_name: "" },
          { contact_first_name: "", contact_last_name: "" }
        ]
      end
    end

    describe "#submit" do
      context "when the form is valid" do
        it "updates the transient registration with the contact name" do
          first_name = "Joe"
          last_name = "Bloggs"
          valid_params = { contact_first_name: first_name, contact_last_name: last_name }
          transient_registration = form.transient_registration

          expect(transient_registration.contact_first_name).to be_blank
          expect(transient_registration.contact_last_name).to be_blank
          form.submit(valid_params)
          expect(transient_registration.contact_first_name).to eq(first_name)
          expect(transient_registration.contact_last_name).to eq(last_name)
        end
      end
    end
  end
end
