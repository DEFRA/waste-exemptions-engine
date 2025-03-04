# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe CertificatePresenter do
    subject(:presenter) { described_class.new(registration) }

    describe "#partners_names" do
      let(:registration) { build(:registration, :partnership) }

      it "returns an html formatted string of partners names" do
        result = registration.people.map do |partner|
          "#{partner.first_name} #{partner.last_name}"
        end.join("</br>")

        expect(presenter.partners_names).to eq(result)
      end
    end

    describe "#sorted_active_registration_exemptions" do
      let(:registration) { build(:registration, :with_expired_and_active_exemptions) }
      let(:exemptions) { registration.exemptions }
      let(:active_exemptions) { registration.active_exemptions }
      let(:inactive_exemptions) { exemptions - active_exemptions }

      it "returns all active exemptions" do
        expect(presenter.sorted_active_registration_exemptions).to eq active_exemptions.sort_by(&:code)
      end

      it "does not return inactive registrations" do
        expect(presenter.sorted_active_registration_exemptions).not_to include(inactive_exemptions)
      end
    end

    describe "#sorted_deregistered_registration_exemptions" do
      let(:registration) { build(:registration, :with_expired_and_active_exemptions) }
      let(:exemptions) { registration.exemptions }
      let(:active_exemptions) { registration.active_exemptions }
      let(:inactive_exemptions) { exemptions - active_exemptions }

      it "returns all inactive exemptions" do
        expect(presenter.sorted_active_registration_exemptions).to eq inactive_exemptions.sort_by(&:code)
      end

      it "does not return active registrations" do
        expect(presenter.sorted_active_registration_exemptions).not_to include(active_exemptions)
      end
    end

    describe "#ceased_or_revoked_on" do
      subject(:ceased_text) { presenter.ceased_or_revoked_on(registration_exemption) }

      let(:registration) { build(:registration) }
      let(:registration_exemption) { build(:registration_exemption, state:) }

      context "when the exemption has been ceased" do
        let(:state) { "ceased" }

        it { expect(ceased_text).to match(/^Ceased on/) }
      end

      context "when the exemption has been revoked" do
        let(:state) { "revoked" }

        it { expect(ceased_text).to match(/^Revoked on/) }
      end

      context "when the exemption is neither ceased nor revoked" do
        let(:state) { "active" }

        it { expect(ceased_text).to eq("") }
      end
    end
  end
end
