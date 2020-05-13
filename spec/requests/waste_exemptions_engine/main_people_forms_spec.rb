# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Main People Forms", type: :request do
    let(:form_factory) { :main_people_form }
    let(:form) { build(form_factory) }
    let(:form_path) { "/waste_exemptions_engine/#{form.token}/main-people" }
    let(:add_another) { I18n.t("waste_exemptions_engine.#{form_factory}s.new.add_person_link") }
    let(:person_one) { { first_name: "Joe", last_name: "Bloggs" } }
    let(:person_two) { { first_name: "Jane", last_name: "Smith" } }

    status_code = WasteExemptionsEngine::ApplicationController::SUCCESSFUL_REDIRECTION_CODE

    include_examples "GET form", :main_people_form, "/main-people"
    include_examples "go back", :main_people_form, "/main-people/back"
    include_examples "POST form", :main_people_form, "/main-people" do
      let(:form_data) { person_one }
      # TODO: There is a strange behaviour in validation of partners,
      # which must be fixed before this can be implemented correctly.
      # Tickets RUBY-463
      let(:invalid_form_data) { [] }
    end

    describe "POST main_people_form" do
      let(:add_person_post_request_path) { "/waste_exemptions_engine/#{form.token}/main-people" }
      let(:person_one_request_body) { { form_factory => person_one, commit: add_another } }
      let(:person_two_request_body) { { form_factory => person_two, commit: add_another } }
      let(:trans_reg_id) { form.transient_registration.id }

      describe "submit and add another" do
        it "re-renders the form template and returns a #{status_code} status code" do
          post add_person_post_request_path, person_one_request_body

          expect(response.location).to include(form_path)
          expect(response.code).to eq(status_code.to_s)
        end

        context "when adding multiple people" do
          it "updates the transient registration accordingly" do
            transient_registration = form.transient_registration

            expect { post add_person_post_request_path, person_one_request_body }
              .to change { transient_registration.reload.people.count }
              .from(0).to(1)
            expect { post add_person_post_request_path, person_two_request_body }
              .to change { transient_registration.reload.people.count }
              .from(1).to(2)

            expect(transient_registration.people.map(&:first_name)).to match_array(%w[Joe Jane])
            expect(transient_registration.people.map(&:last_name)).to match_array(%w[Bloggs Smith])
          end
        end
      end

      describe "DELETE person" do
        let(:person_one) { create(:transient_person) }
        let(:person_two) { create(:transient_person) }

        before(:each) { form.transient_registration.people = [person_one, person_two] }

        it "re-renders the form template and returns a #{status_code} status code" do
          delete delete_person_main_people_forms_path(token: form.token, id: person_one.id)

          expect(response.location).to include(form_path)
          expect(response.code).to eq(status_code.to_s)
        end

        context "when deleting multiple people" do
          it "updates the transient registration accordingly" do
            expect { delete delete_person_main_people_forms_path(token: form.token, id: person_one.id) }
              .to change { WasteExemptionsEngine::TransientRegistration.find(trans_reg_id).people.count }
              .from(2).to(1)
            expect { delete delete_person_main_people_forms_path(token: form.token, id: person_two.id) }
              .to change { WasteExemptionsEngine::TransientRegistration.find(trans_reg_id).people.count }
              .from(1).to(0)
          end
        end
      end
    end
  end
end
