# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe MultipleSitesForm, type: :model do
    subject(:form) { build(:multiple_sites_form) }

    describe "#site_addresses" do
      let(:transient_registration) { form.transient_registration }

      context "when there are no site addresses" do
        it "returns an empty paginated collection" do
          result = form.site_addresses
          expect(result).to be_empty
        end
      end

      context "when there are site addresses" do
        before do
          create_list(:transient_address, 5,
                      transient_registration: transient_registration,
                      address_type: "site")
          create(:transient_address,
                 transient_registration: transient_registration,
                 address_type: "contact")
        end

        it "returns only site addresses" do
          allow(form).to receive(:sites_per_page).and_return(10)
          result = form.site_addresses
          expect(result.count).to eq(5)
        end

        it "paginates the results" do
          allow(form).to receive(:sites_per_page).and_return(2)
          result = form.site_addresses(1)
          expect(result.count).to eq(2)
        end

        it "returns the correct page of results" do
          allow(form).to receive(:sites_per_page).and_return(2)
          page_2_result = form.site_addresses(2)
          expect(page_2_result.count).to eq(2)
        end
      end
    end

    describe "#total_sites_count" do
      let(:transient_registration) { form.transient_registration }

      context "when there are no site addresses" do
        it "returns 0" do
          expect(form.total_sites_count).to eq(0)
        end
      end

      context "when there are site addresses" do
        before do
          create_list(:transient_address, 3,
                      transient_registration: transient_registration,
                      address_type: "site")
          create(:transient_address,
                 transient_registration: transient_registration,
                 address_type: "contact")
        end

        it "returns only the count of site addresses" do
          expect(form.total_sites_count).to eq(3)
        end
      end
    end

    describe "#can_continue?" do
      let(:transient_registration) { form.transient_registration }

      context "when there are fewer sites than the minimum required" do
        before do
          allow(form).to receive(:minimum_sites_required).and_return(3)
          create_list(:transient_address, 2,
                      transient_registration: transient_registration,
                      address_type: "site")
        end

        it "returns false" do
          expect(form.can_continue?).to be false
        end
      end

      context "when there are exactly the minimum required sites" do
        before do
          allow(form).to receive(:minimum_sites_required).and_return(3)
          create_list(:transient_address, 3,
                      transient_registration: transient_registration,
                      address_type: "site")
        end

        it "returns true" do
          expect(form.can_continue?).to be true
        end
      end

      context "when there are more sites than the minimum required" do
        before do
          allow(form).to receive(:minimum_sites_required).and_return(3)
          create_list(:transient_address, 5,
                      transient_registration: transient_registration,
                      address_type: "site")
        end

        it "returns true" do
          expect(form.can_continue?).to be true
        end
      end
    end

    describe "#minimum_sites_required" do
      context "when MULTISITE_MINIMUM_SITES environment variable is set" do
        before do
          allow(ENV).to receive(:fetch).with("MULTISITE_MINIMUM_SITES", 30).and_return("5")
        end

        it "returns the environment variable value as integer" do
          expect(form.minimum_sites_required).to eq(5)
        end
      end

      context "when MULTISITE_MINIMUM_SITES environment variable is not set" do
        before do
          allow(ENV).to receive(:fetch).with("MULTISITE_MINIMUM_SITES", 30).and_return(3)
        end

        it "returns the default value" do
          expect(form.minimum_sites_required).to eq(3)
        end
      end
    end

    describe "#sites_per_page" do
      context "when MULTISITE_PAGINATION_SIZE environment variable is set" do
        before do
          allow(ENV).to receive(:fetch).with("MULTISITE_PAGINATION_SIZE", 20).and_return("10")
        end

        it "returns the environment variable value as integer" do
          expect(form.sites_per_page).to eq(10)
        end
      end

      context "when MULTISITE_PAGINATION_SIZE environment variable is not set" do
        before do
          allow(ENV).to receive(:fetch).with("MULTISITE_PAGINATION_SIZE", 20).and_return(2)
        end

        it "returns the default value" do
          expect(form.sites_per_page).to eq(2)
        end
      end
    end
  end
end
