# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe EditRegistration, type: :model do
    subject(:edit_registration) { create(:edit_registration) }

    it_behaves_like "a transient_registration", :edit_registration

    it "subclasses TransientRegistration" do
      expect(described_class).to be < TransientRegistration
    end

    describe "public interface" do
      Helpers::ModelProperties::TRANSIENT_REGISTRATION.each do |property|
        it "responds to property" do
          expect(edit_registration).to respond_to(property)
        end
      end
    end

    describe "#renewal?" do
      it "returns false" do
        expect(edit_registration).to_not be_a_renewal
      end
    end

    describe "#initialize" do
      context "when it is initialized with a registration" do
        let(:registration) { create(:registration, :complete) }
        let(:edit_registration) { described_class.new(reference: registration.reference) }

        copyable_properties = Helpers::ModelProperties::REGISTRATION - %i[id
                                                                          assistance_mode
                                                                          created_at
                                                                          updated_at
                                                                          submitted_at]

        copyable_properties.each do |property|
          it "copies #{property} from the registration" do
            expect(edit_registration[property]).to eq(registration[property])
          end
        end

        it "copies the addresses from the registration" do
          registration.addresses.each do |address|
            copyable_attributes = address.attributes.except("id",
                                                            "registration_id",
                                                            "created_at",
                                                            "updated_at")

            edit_address_attributes = edit_registration.public_send("#{address.address_type}_address")
                                                       .attributes
            expect(edit_address_attributes).to include(copyable_attributes)
          end
        end

        it "copies the people from the registration" do
          registration.people.each_with_index do |person, index|
            copyable_attributes = person.attributes.except("id",
                                                           "registration_id",
                                                           "created_at",
                                                           "updated_at")
            expect(edit_registration.people[index].attributes).to include(copyable_attributes)
          end
        end

        it "copies the active exemptions from the registration" do
          registration.registration_exemptions.each do |re|
            re.state = :active
            re.save
          end

          registration.exemptions.each do |exemption|
            expect(edit_registration.exemptions).to include(exemption)
          end
        end

        it "does not copy the expired exemptions from the registration" do
          registration.registration_exemptions.each do |re|
            re.state = :expired
            re.save
          end

          registration.exemptions.each do |exemption|
            expect(edit_registration.exemptions).to_not include(exemption)
          end
        end

        it "does not copy revoked exemptions from the registration" do
          registration.registration_exemptions.each do |re|
            re.state = :revoked
            re.save
          end

          registration.exemptions.each do |exemption|
            expect(edit_registration.exemptions).to_not include(exemption)
          end
        end

        it "does not copy ceased exemptions from the registration" do
          registration.registration_exemptions.each do |re|
            re.state = :ceased
            re.save
          end

          registration.exemptions.each do |exemption|
            expect(edit_registration.exemptions).to_not include(exemption)
          end
        end
      end
    end
  end
end
