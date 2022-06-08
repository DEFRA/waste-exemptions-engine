# frozen_string_literal: true

require "rails_helper"
require "defra_ruby_companies_house"

RSpec.describe WasteExemptionsEngine::RefreshCompaniesHouseNameService do

  let(:new_registration_name) { Faker::Company.name }
  let(:registration) { create(:registration, :complete, operator_name: old_registered_name) }
  let(:reference) { registration.reference }
  let(:companies_house_name) { new_registration_name }

  before do
    allow_any_instance_of(DefraRubyCompaniesHouse).to receive(:load_company)
    allow_any_instance_of(DefraRubyCompaniesHouse).to receive(:company_name).and_return(companies_house_name)
  end

  subject { described_class.run(reference) }

  context "with no previous companies house name" do
    let(:old_registered_name) { nil }

    it "stores the companies house name" do
      expect { subject }.to change { registration_data(registration).operator_name }
        .from(nil)
        .to(new_registration_name)
    end
  end

  context "with an existing registered company name" do
    let(:old_registered_name) { Faker::Company.name }

    context "when the new company name is the same as the old one" do
      let(:new_registration_name) { old_registered_name }

      it "does not change companies house name" do
        expect { subject }.not_to change { registration_data(registration).operator_name }
      end
    end

    context "when the new company name is different to the old one" do
      it "updates the registered company name" do
        expect { subject }
          .to change { registration_data(registration).operator_name }
          .from(old_registered_name)
          .to(new_registration_name)
      end
    end
  end
end

def registration_data(registration)
  WasteExemptionsEngine::Registration.find_by(reference: registration.reference)
end
