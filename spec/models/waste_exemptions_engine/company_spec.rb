# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe Company do
    describe "validations" do
      subject(:company) { build(:company) }

      context "when validating company_no uniqueness" do
        let(:existing_company) { create(:company, company_no: "12345678") }
        let(:new_company) { build(:company, company_no: existing_company.company_no) }

        it "is not valid with a duplicate company_no" do
          expect(new_company).not_to be_valid
        end

        it "adds the correct error message" do
          new_company.valid?
          expect(new_company.errors[:company_no]).to include("has already been taken")
        end

        it "allows creation with a unique company_no" do
          second_company = build(:company, company_no: "87654321")
          expect(second_company).to be_valid
        end
      end
    end

    describe "scopes" do
      describe ".recently_updated" do
        let!(:recent_company) { create(:company, updated_at: 2.months.ago) }
        let!(:old_company) { create(:company, updated_at: 4.months.ago) }
        let!(:very_old_company) { create(:company, updated_at: 6.months.ago) }

        it "includes companies updated within the last 3 months" do
          expect(described_class.recently_updated).to include(recent_company)
        end

        it "excludes companies updated more than 3 months ago" do
          expect(described_class.recently_updated).not_to include(old_company)
        end

        it "excludes companies updated more than 6 months ago" do
          expect(described_class.recently_updated).not_to include(very_old_company)
        end

        context "when a company is updated now" do
          before { old_company.touch }

          it "includes the newly updated company" do
            expect(described_class.recently_updated).to include(old_company)
          end
        end
      end
    end

    describe ".find_or_create_by_company_no" do
      context "when the company does not exist" do
        let(:company_no) { "12345678" }
        let(:name) { "TEST COMPANY LTD" }

        it "creates a new company record" do
          expect do
            described_class.find_or_create_by_company_no(company_no, name)
          end.to change(described_class, :count).by(1)
        end

        it "sets the correct company_no" do
          company = described_class.find_or_create_by_company_no(company_no, name)
          expect(company.company_no).to eq(company_no)
        end

        it "sets the correct name" do
          company = described_class.find_or_create_by_company_no(company_no, name)
          expect(company.name).to eq(name)
        end

        it "returns a persisted record" do
          company = described_class.find_or_create_by_company_no(company_no, name)
          expect(company).to be_persisted
        end

        it "returns a Company instance" do
          company = described_class.find_or_create_by_company_no(company_no, name)
          expect(company).to be_a(described_class)
        end
      end

      context "when the company already exists" do
        let!(:existing_company) { create(:company, company_no: "12345678", name: "ORIGINAL NAME LTD") }
        let(:new_name) { "NEW NAME LTD" }

        it "does not create a new record" do
          expect do
            described_class.find_or_create_by_company_no(existing_company.company_no, new_name)
          end.not_to change(described_class, :count)
        end

        it "returns the existing company" do
          company = described_class.find_or_create_by_company_no(existing_company.company_no, new_name)
          expect(company.id).to eq(existing_company.id)
        end

        it "does not update the existing name" do
          company = described_class.find_or_create_by_company_no(existing_company.company_no, new_name)
          expect(company.name).to eq("ORIGINAL NAME LTD")
        end

        it "maintains the original updated_at timestamp" do
          original_updated_at = existing_company.updated_at
          described_class.find_or_create_by_company_no(existing_company.company_no, new_name)
          expect(existing_company.reload.updated_at).to be_within(1.second).of(original_updated_at)
        end
      end

      context "with edge cases" do
        context "when name is nil" do
          it "persists the record" do
            company = described_class.find_or_create_by_company_no("99999999", nil)
            expect(company).to be_persisted
          end

          it "sets the name to nil" do
            company = described_class.find_or_create_by_company_no("99999999", nil)
            expect(company.name).to be_nil
          end
        end

        context "when name is an empty string" do
          it "persists the record" do
            company = described_class.find_or_create_by_company_no("99999999", "")
            expect(company).to be_persisted
          end

          it "sets the name to an empty string" do
            company = described_class.find_or_create_by_company_no("99999999", "")
            expect(company.name).to eq("")
          end
        end

        it "handles duplicate calls with same data" do
          expect do
            2.times { described_class.find_or_create_by_company_no("11111111", "DUPLICATE TEST LTD") }
          end.to change(described_class, :count).by(1)
        end
      end
    end
  end
end
