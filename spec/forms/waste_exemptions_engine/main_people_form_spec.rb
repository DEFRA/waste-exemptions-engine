# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe MainPeopleForm, type: :model do
    subject(:form) { build(:main_people_form) }

    it "should be a type of PersonForm" do
      expect(described_class.ancestors)
        .to include(WasteExemptionsEngine::PersonForm)
    end

    it "validates the person using the MainPersonValidator class" do
      validators = form._validators
      validator_classes = validators.values.flatten.map(&:class)
      expect(validator_classes).to include(WasteExemptionsEngine::MainPersonValidator)
    end

    it_behaves_like "a validated form", :main_people_form do
      let(:valid_params) do
        { token: form.token, first_name: "Joe", last_name: "Bloggs" }
      end
      let(:invalid_params) do
        [
          { token: form.token, first_name: "", last_name: "Bloggs" },
          { token: form.token, first_name: "Joe", last_name: "" },
          { token: form.token, first_name: "", last_name: "" }
        ]
      end
    end

    describe "#submit" do
      context "when the form is valid" do
        it "updates the transient registration with the main person" do
          first_name = "Joe"
          last_name = "Bloggs"
          person_type = "partner"
          valid_params = { token: form.token, first_name: first_name, last_name: last_name }
          transient_registration = form.transient_registration

          expect(transient_registration.transient_people).to be_empty
          form.submit(valid_params)
          expect(transient_registration.transient_people.count).to eq(1)
          person = transient_registration.transient_people.first
          expect(person.first_name).to eq(first_name)
          expect(person.last_name).to eq(last_name)
          expect(person.person_type).to eq(person_type)
        end
      end
    end
  end
end
