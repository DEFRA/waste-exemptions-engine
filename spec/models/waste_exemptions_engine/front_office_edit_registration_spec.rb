# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine

  copyable_properties = %i[
    reference
    contact_first_name
    contact_last_name
    contact_phone
    contact_email
  ].freeze

  RSpec.describe FrontOfficeEditRegistration do
    subject(:edit_registration) { create(:front_office_edit_registration) }

    it_behaves_like "a transient_registration", :front_office_edit_registration

    it "subclasses TransientRegistration" do
      expect(described_class).to be < TransientRegistration
    end

    describe "public interface" do

      copyable_properties.each do |property|
        it "responds to property" do
          expect(edit_registration).to respond_to(property)
        end
      end
    end

    describe "#initialize" do
      context "when it is initialized with a registration" do
        let(:registration) { create(:registration, :complete) }
        let(:edit_registration) { described_class.new(reference: registration.reference) }

        copyable_properties.each do |property|
          it "copies #{property} from the registration" do
            expect(edit_registration[property]).to eq(registration[property])
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
            expect(edit_registration.exemptions).not_to include(exemption)
          end
        end

        it "does not copy revoked exemptions from the registration" do
          registration.registration_exemptions.each do |re|
            re.state = :revoked
            re.save
          end

          registration.exemptions.each do |exemption|
            expect(edit_registration.exemptions).not_to include(exemption)
          end
        end

        it "does not copy ceased exemptions from the registration" do
          registration.registration_exemptions.each do |re|
            re.state = :ceased
            re.save
          end

          registration.exemptions.each do |exemption|
            expect(edit_registration.exemptions).not_to include(exemption)
          end
        end
      end
    end
  end
end
