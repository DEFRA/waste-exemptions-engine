# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe RegistrationExemption, type: :model do
    describe "public interface" do
      subject(:registration_exemption) { build(:registration_exemption) }

      associations = %i[registration exemption]

      (Helpers::ModelProperties::REGISTRATION_EXEMPTION + associations).each do |property|
        it "responds to property" do
          expect(registration_exemption).to respond_to(property)
        end
      end
    end

    describe ".too_late_to_renew?" do
      subject(:registration_exemption) { build(:registration_exemption) }

      context "when the exemption is not past the expiry date" do
        before { registration_exemption.expires_on = Date.tomorrow }

        it "returns false" do
          expect(registration_exemption.too_late_to_renew?).to be_falsey
        end
      end

      context "when the exemption is past the expiry date" do
        before { registration_exemption.expires_on = Date.yesterday }

        context "when the exemption is still in the renewal grace period" do
          before do
            allow(WasteExemptionsEngine.configuration).to receive(:registration_renewal_grace_window).and_return(28)
          end

          it "returns false" do
            expect(registration_exemption.too_late_to_renew?).to be_falsey
          end
        end

        context "when the exemption is outside the renewal grace period" do
          before do
            allow(WasteExemptionsEngine.configuration).to receive(:registration_renewal_grace_window).and_return(0)
          end

          it "returns true" do
            expect(registration_exemption.too_late_to_renew?).to be_truthy
          end
        end
      end
    end
  end
end
