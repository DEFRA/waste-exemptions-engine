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

    describe "#unique_active_registration_exemptions" do
      let(:registration) { create(:registration, :complete) }
      let(:exemption_a) { create(:exemption) }
      let(:exemption_b) { create(:exemption) }

      before do
        registration.registration_exemptions.destroy_all
        site1 = registration.site_addresses.first || create(:address, :site_address, registration: registration)
        site2 = create(:address, :site_address, registration: registration)

        create(:registration_exemption, registration: registration, exemption: exemption_a, address: site1)
        create(:registration_exemption, registration: registration, exemption: exemption_b, address: site1)
        create(:registration_exemption, registration: registration, exemption: exemption_a, address: site2)
        create(:registration_exemption, registration: registration, exemption: exemption_b, address: site2)
      end

      it "returns each exemption only once" do
        result = presenter.unique_active_registration_exemptions
        exemption_ids = result.map(&:exemption_id)

        aggregate_failures do
          expect(exemption_ids).to contain_exactly(exemption_a.id, exemption_b.id)
          expect(result.size).to eq(2)
        end
      end
    end

    describe "#deregistered_exemptions_for_site" do
      let(:registration) { create(:registration, :complete) }
      let(:site1) { create(:address, :site_address, registration: registration) }

      before do
        create(:registration_exemption, registration: registration, address: site1, state: :ceased,
                                        deregistered_at: 1.day.ago)
        create(:registration_exemption, registration: registration, address: site1, state: :revoked,
                                        deregistered_at: 2.days.ago)
      end

      it "returns only deregistered exemptions for the given site" do
        result = presenter.deregistered_exemptions_for_site(site1)

        aggregate_failures do
          expect(result.size).to eq(2)
          expect(result.map(&:state)).to all(be_in(%w[ceased revoked]))
          expect(result.map(&:address_id)).to all(eq(site1.id))
        end
      end
    end

    describe "#expiry_date" do
      let(:registration) { create(:registration, :complete) }

      it "returns a formatted expiry date string" do
        expect(presenter.expiry_date).to be_a(String)
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
