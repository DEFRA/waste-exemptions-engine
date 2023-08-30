# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe RegistrationEmailMatchService do
    describe ".run" do
      let(:registration) { create(:registration) }
      let(:reference) { "WEX0123456" }
      let(:email) { Faker::Internet.email }

      context "when the match is successful" do
        context "with registration contact_email matching" do
          before do
            registration.update(reference: reference, contact_email: email)
          end

          it "returns matching registration record" do
            expect(described_class.run(reference: reference, email: email)).to eq(registration)
          end

          it "performs case insensitive search for registration reference" do
            expect(described_class.run(reference: reference.downcase, email: email)).to eq(registration)
          end

          it "performs case insensitive search for email" do
            expect(described_class.run(reference: reference, email: email.upcase)).to eq(registration)
          end
        end

        context "with registration applicant_email matching" do
          before do
            registration.update(reference: reference, applicant_email: email)
          end

          it "returns matching registration record" do
            expect(described_class.run(reference: reference, email: email)).to eq(registration)
          end

          it "performs case insensitive search for registration reference" do
            expect(described_class.run(reference: reference.downcase, email: email)).to eq(registration)
          end

          it "performs case insensitive search for email" do
            expect(described_class.run(reference: reference, email: email.upcase)).to eq(registration)
          end
        end
      end

      context "when the match is unsuccessful" do
        context "with no match found" do
          it "returns false" do
            expect(described_class.run(reference: reference, email: email)).to be_falsey
          end
        end
      end
    end
  end
end
