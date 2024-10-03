# frozen_string_literal: true

require "rails_helper"

class RegistrableTest
  include WasteExemptionsEngine::CanHaveViewCertificateToken

  attr_accessor :view_certificate_token, :view_certificate_token_created_at

  def save!
    true
  end
end

module WasteExemptionsEngine
  RSpec.describe "CanHaveViewCertificateToken" do

    subject(:registrable) { RegistrableTest.new }

    describe "#generate_view_certificate_token!" do
      it "generates a token" do
        expect { registrable.generate_view_certificate_token! }.to change(registrable, :view_certificate_token).from(nil)
      end

      it "sets the token timestamp" do
        expect { registrable.generate_view_certificate_token! }.to change(registrable, :view_certificate_token_created_at).from(nil)
      end

      it "returns the token" do
        expect(registrable.generate_view_certificate_token!).to eq(registrable.view_certificate_token)
      end

      context "when the token has already been generated" do
        it "updates the token" do
          registrable.generate_view_certificate_token!
          expect { registrable.generate_view_certificate_token! }.to change(registrable, :view_certificate_token)
        end

        it "updates the token timestamp" do
          registrable.generate_view_certificate_token!
          Timecop.travel(1.second.from_now)
          expect { registrable.generate_view_certificate_token! }.to change(registrable, :view_certificate_token_created_at)
        end
      end
    end

    describe "#view_certificate_token_valid?" do
      context "when the token has not been generated" do
        it "returns false" do
          expect(registrable.view_certificate_token_valid?).to be(false)
        end
      end

      context "when the token has been generated" do
        before do
          registrable.generate_view_certificate_token!
        end

        it "returns true" do
          expect(registrable.view_certificate_token_valid?).to be(true)
        end
      end
    end
  end
end
