# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe OperationSitesForm, type: :model do
    subject(:form) { build(:operation_sites_form) }

    describe "#site_status" do
      let(:transient_registration) { form.transient_registration }

      context "when there are no pending exemptions" do
        before do
          transient_registration.transient_registration_exemptions.each do |re|
            re.state = "deregistered"
          end
          transient_registration.save!
        end

        it "returns 'deregistered' for site status" do
          address = transient_registration.transient_addresses.first
          expect(form.site_status(address)).to eq("deregistered")
        end
      end

      context "when there are pending exemptions" do
        before do
          transient_registration.transient_registration_exemptions.each do |re|
            re.state = "deregistered"
          end
          transient_registration.transient_registration_exemptions.first.state = "pending"
          transient_registration.save!
        end

        it "returns 'pending' for site status" do
          address = transient_registration.transient_addresses.first
          expect(form.site_status(address)).to eq("pending")
        end
      end
    end

  end
end
