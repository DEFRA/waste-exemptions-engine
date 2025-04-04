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

    describe ".modified?" do
      context "when no changes have been made" do
        it { expect(edit_registration.modified?).to be false }
      end

      context "when an exemption has been removed" do
        before { edit_registration.exemptions.last.destroy }

        context "when no parameter passed to modifield? metod" do
          it { expect(edit_registration.modified?).to be true }
        end

        context "when ignore_exemptions parameter set to false" do
          it { expect(edit_registration.modified?(ignore_exemptions: false)).to be true }
        end

        context "when ignore_exemptions parameter set to true" do
          it { expect(edit_registration.modified?(ignore_exemptions: true)).to be false }
        end
      end

      context "when contact first name has been updated" do
        before { edit_registration.contact_first_name = "foo" }

        it { expect(edit_registration.modified?).to be true }
      end

      context "when contact last name has been updated" do
        before { edit_registration.contact_last_name = "foo" }

        it { expect(edit_registration.modified?).to be true }
      end

      context "when contact phone has been updated" do
        before { edit_registration.contact_phone = "000000000" }

        it { expect(edit_registration.modified?).to be true }
      end

      context "when contact email has been updated" do
        before { edit_registration.contact_email = "foo@bar.co.uk" }

        it { expect(edit_registration.modified?).to be true }
      end

      context "when contact address has been updated" do
        before { edit_registration.contact_address.postcode = "BS1 5AH" }

        it { expect(edit_registration.modified?).to be true }
      end
    end
  end
end
