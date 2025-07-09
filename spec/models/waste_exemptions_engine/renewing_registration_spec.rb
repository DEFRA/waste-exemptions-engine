# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe RenewingRegistration do
    subject(:renewing_registration) { create(:renewing_registration) }

    it_behaves_like "a transient_registration", :renewing_registration

    describe "#registration_attributes" do
      it "includes a referring registration id" do
        attributes = renewing_registration.registration_attributes
        expect(attributes.keys).to include("referring_registration_id")
      end
    end

    it "subclasses TransientRegistration" do
      expect(described_class).to be < TransientRegistration
    end

    describe "public interface" do
      Helpers::ModelProperties::TRANSIENT_REGISTRATION.each do |property|
        it "responds to property" do
          expect(renewing_registration).to respond_to(property)
        end
      end
    end

    describe "#renewal?" do
      it "returns true" do
        expect(renewing_registration).to be_a_renewal
      end
    end

    describe "#initialize" do
      context "when the registration has unknown attributes" do
        let(:registration) { create(:registration, :complete) }
        let(:renewing_registration) { create(:renewing_registration) }

        before do
          allow(Registration).to receive(:find_by).and_return(registration)
          allow(registration).to receive(:attributes).and_return({ "unknown_attribute" => "unknown_value" })
        end

        it "does not raise UnknownAttributeError" do
          expect { renewing_registration }.not_to raise_error
        end
      end

      context "when it is initialized with a registration" do
        let(:registration) { create(:registration, :complete) }
        let(:renewing_registration) { described_class.new(reference: registration.reference) }

        copyable_properties = Helpers::ModelProperties::REGISTRATION - %i[id
                                                                          assistance_mode
                                                                          created_at
                                                                          updated_at
                                                                          submitted_at]

        copyable_properties.each do |property|
          it "copies #{property} from the registration" do
            expect(renewing_registration[property]).to eq(registration[property])
          end
        end

        it "copies the addresses from the registration" do
          registration.addresses.each do |address|
            copyable_attributes = address.attributes.except("id",
                                                            "registration_id",
                                                            "created_at",
                                                            "updated_at")

            renewing_address_attributes = renewing_registration.public_send("#{address.address_type}_address").attributes

            expect(renewing_address_attributes).to include(copyable_attributes)
          end
        end

        it "copies the people from the registration" do
          registration.people.each do |person|
            copyable_attributes = person.attributes.except("id",
                                                           "registration_id",
                                                           "created_at",
                                                           "updated_at")

            renewing_person = renewing_registration.people.find do |find_person|
              # Rubocop Style/BitwisePredicate returns a false positive here - this is a set union, not a bitwise operation
              (find_person.attributes.to_a & copyable_attributes.to_a) == copyable_attributes.to_a # rubocop:disable Style/BitwisePredicate
            end

            expect(renewing_person).to be_present
          end
        end

        it "copies the active exemptions from the registration" do
          registration.registration_exemptions.each do |re|
            re.state = :active
            re.save
          end

          registration.exemptions.each do |exemption|
            expect(renewing_registration.exemptions).to include(exemption)
          end
        end

        it "copies the expired exemptions from the registration" do
          registration.registration_exemptions.each do |re|
            re.state = :expired
            re.save
          end

          registration.exemptions.each do |exemption|
            expect(renewing_registration.exemptions).to include(exemption)
          end
        end

        it "does not copy revoked exemptions from the registration" do
          registration.registration_exemptions.each do |re|
            re.state = :revoked
            re.save
          end

          registration.exemptions.each do |exemption|
            expect(renewing_registration.exemptions).not_to include(exemption)
          end
        end

        it "does not copy ceased exemptions from the registration" do
          registration.registration_exemptions.each do |re|
            re.state = :ceased
            re.save
          end

          registration.exemptions.each do |exemption|
            expect(renewing_registration.exemptions).not_to include(exemption)
          end
        end

        it "sets temp_company_no when company_no is present" do
          expect(renewing_registration.temp_company_no).to eq(registration.company_no)
        end
      end
    end
  end
end
