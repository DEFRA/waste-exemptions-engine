# frozen_string_literal: true

require "rails_helper"
require "defra_ruby_companies_house"

RSpec.describe DefraRubyCompaniesHouse do

  let(:valid_company_no) { "00987654" }
  let(:short_company_no) { "1987654" }
  let(:invalid_company_no) { "-" }
  let(:inactive_company) { "07052532" }

  before do
    # stub all calls to fail first....
    stub_request(:get, /#{Rails.configuration.companies_house_host}*/).to_return(
      status: 404
    )
    # ... then add a stub to cover valid company_no values
    stub_request(:get, /#{Rails.configuration.companies_house_host}[a-zA-Z\d]{8}/).to_return(
      status: 200,
      body: File.read("spec/fixtures/files/companies_house_response.json")
    )
  end

  describe "#company_name" do
    subject(:companies_house_name) { described_class.new(company_no).company_name }

    context "with an invalid company number" do
      let(:company_no) { invalid_company_no }

      it "raises a standard error" do
        expect { companies_house_name }.to raise_error(StandardError)
      end
    end

    context "with a valid company number" do
      let(:company_no) { valid_company_no }

      it "returns the company name" do
        expect(companies_house_name).to eq "BOGUS LIMITED"
      end
    end

    context "with a short company number" do
      let(:company_no) { short_company_no }

      it "returns the company name" do
        expect(companies_house_name).to eq "BOGUS LIMITED"
      end
    end
  end

  describe "#registered_office_address_lines" do
    subject(:companies_house_address) { described_class.new(company_no).registered_office_address_lines }

    context "with an invalid company number" do
      let(:company_no) { invalid_company_no }

      it "raises a standard error" do
        expect { companies_house_address }.to raise_error(StandardError)
      end
    end

    context "with a valid company number" do
      let(:company_no) { valid_company_no }

      it "returns the address lines" do
        expect(companies_house_address).to eq ["R House", "Middle Street", "Thereabouts", "HD1 2BN"]
      end
    end

    context "with a short company number" do
      let(:company_no) { short_company_no }

      it "returns the address lines" do
        expect(companies_house_address).to eq ["R House", "Middle Street", "Thereabouts", "HD1 2BN"]
      end
    end
  end

  context "when there is a problem with the companies house API" do
    subject(:companies_house_instance) { described_class.new(company_no) }

    context "when the requests time out" do
      it "raises a standard error" do
        expect { companies_house_instance }.to raise_error(StandardError)
      end
    end

    context "when requests return an error" do
      before { stub_request(:get, /#{Rails.configuration.companies_house_host}*/).to_raise(SocketError) }

      it "raises an exception" do
        expect { companies_house_instance.status }.to raise_error(StandardError)
      end
    end
  end

  describe "#status" do
    subject(:companies_house_status) { described_class.new(company_no).status }

    context "when the company is no longer active" do
      let(:company_no) { inactive_company }

      before do
        stub_request(:get, /#{Rails.configuration.companies_house_host}[a-zA-Z\d]{8}/).to_return(
          status: 200,
          body: File.read("spec/fixtures/files/inactive_companies_house_response.json")
        )
      end

      it "returns false" do
        expect(companies_house_status).to eq(:inactive)
      end
    end

    context "when the company is active" do
      let(:company_no) { valid_company_no }

      it "returns true" do
        expect(companies_house_status).to eq(:active)
      end
    end
  end
end
