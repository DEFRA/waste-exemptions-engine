# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe CheckYourAnswersForm, type: :model do
    let(:form) { build(:check_your_answers_form) }

    it_behaves_like "a data overview form", :check_your_answers_form

    describe "validations" do
      subject(:validators) { form._validators }

      expected_validators = [
        { property: :location, validator: :location_validator, namespace: "DefraRuby::Validators" },
        { property: :applicant_first_name, validator: :person_name_validator },
        { property: :applicant_last_name, validator: :person_name_validator },
        { property: :applicant_phone, validator: :phone_number_validator, namespace: "DefraRuby::Validators" },
        { property: :business_type, validator: :business_type_validator, namespace: "DefraRuby::Validators" },
        { property: :operator_name, validator: :operator_name_validator },
        { property: :operator_address, validator: :address_validator },
        { property: :contact_first_name, validator: :person_name_validator },
        { property: :contact_last_name, validator: :person_name_validator },
        { property: :contact_position, validator: :position_validator, namespace: "DefraRuby::Validators" },
        { property: :contact_phone, validator: :phone_number_validator, namespace: "DefraRuby::Validators" },
        { property: :contact_address, validator: :address_validator },
        { property: :exemptions, validator: :exemptions_validator },
        { property: :grid_reference, validator: :grid_reference_validator, namespace: "DefraRuby::Validators", options: { if: :uses_site_location? } },
        { property: :description, validator: :site_description_validator, options: { if: :uses_site_location? } },
        { property: :site_address, validator: :address_validator, options: { unless: :uses_site_location? } }
      ]

      expected_validators.each do |expectation|
        property = expectation[:property]
        validator = expectation[:validator]
        options = expectation[:options]
        namespace = expectation[:namespace] || "WasteExemptionsEngine"
        validator_class = validator.to_s.camelize

        it "validates the #{property} using the #{validator_class} class" do
          expect(validators.keys).to include(property)
          expect(validators[property].first.class)
            .to eq("#{namespace}::#{validator_class}".constantize)

          expect(validators[property].first.options).to eq(options) if options
        end
      end

      it "validates the company_no using the CompaniesHouseNumberValidator class" do
        expect(validators.keys).to include(:company_no)
        expect(validators[:company_no].first.class)
          .to eq(DefraRuby::Validators::CompaniesHouseNumberValidator)

        expect(validators[:company_no].first.options).to eq(if: :company_no_required?)
      end

      %i[on_a_farm is_a_farmer].each do |property|
        it "validates the #{property} using the InclusionValidator class" do
          expect(validators.keys).to include(property)
          expect(validators[property].first.class)
            .to eq(ActiveModel::Validations::InclusionValidator)

          expect(validators[property].first.options).to eq(in: [true, false])
        end
      end
    end

    describe "#new" do
      let(:transient_registration) { form.transient_registration }

      shared_examples "is optional only in the back office" do |email_attribute|
        context "when running in the front office" do
          before { allow(WasteExemptionsEngine.configuration).to receive(:host_is_back_office?).and_return(false) }

          it "raises an error" do
            form.submit(ActionController::Parameters.new({}))
            expect(form.errors.attribute_names).to include(email_attribute)
          end
        end

        context "when running in the back office" do
          before { allow(WasteExemptionsEngine.configuration).to receive(:host_is_back_office?).and_return(true) }

          it "does not raise an error" do
            form.submit(ActionController::Parameters.new({}))
            expect(form.errors.attribute_names).not_to include(email_attribute)
          end
        end
      end

      context "without an applicant_email" do
        before { transient_registration.applicant_email = nil }

        it_behaves_like "is optional only in the back office", :applicant_email
      end

      context "without a contact_email" do
        before { transient_registration.contact_email = nil }

        it_behaves_like "is optional only in the back office", :contact_email
      end
    end
  end
end
