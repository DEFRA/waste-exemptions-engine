# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe RenewingRegistration, type: :model do
    subject(:renewing_registration) { create(:renewing_registration) }

    it_behaves_like "a transient_registration", :renewing_registration

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

    describe "#initialize" do
      context "when it is initialized with a registration" do
        let(:registration) { create(:registration) }
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
          registration.addresses.each_with_index do |address, index|
            copyable_attributes = address.attributes.except("id",
                                                            "registration_id",
                                                            "created_at",
                                                            "updated_at")
            expect(renewing_registration.address[index].attributes).to include(copyable_attributes)
          end
        end

        it "copies the people from the registration" do
          registration.people.each_with_index do |person, index|
            copyable_attributes = person.attributes.except("id",
                                                           "registration_id",
                                                           "created_at",
                                                           "updated_at")
            expect(renewing_registration.people[index].attributes).to include(copyable_attributes)
          end
        end

        it "copies the exemptions from the registration" do
          registration.exemptions.each do |exemption|
            expect(renewing_registration.exemptions).to include(exemption)
          end
        end
      end
    end
  end
end
