# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe MainPeopleForm, type: :model do
    subject(:form) { build(:main_people_form) }

    it_behaves_like "a validated form", :main_people_form do
      let(:valid_params) do
        { first_name: "Joe", last_name: "Bloggs" }
      end
      let(:invalid_params) do
        [
          { first_name: "", last_name: "Bloggs" },
          { first_name: "Joe", last_name: "" },
          { first_name: "", last_name: "" },
          { first_name: "Bob", last_name: "This Name Is Far Too Long 1 .... 36!" }
        ]
      end
    end

    describe "#submit" do
      context "when the form is valid" do
        it "updates the transient registration with the main person" do
          first_name = "Joe"
          last_name = "Bloggs"
          valid_params = { first_name: first_name, last_name: last_name }
          transient_registration = form.transient_registration

          expect(transient_registration.transient_people).to be_empty
          form.submit(valid_params)
          expect(transient_registration.transient_people.count).to eq(1)
          person = transient_registration.transient_people.first
          expect(person.first_name).to eq(first_name)
          expect(person.last_name).to eq(last_name)
        end
      end
    end
  end
end
