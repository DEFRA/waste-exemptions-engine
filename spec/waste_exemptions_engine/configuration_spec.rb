# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe Configuration do
    let(:configuration) { WasteExemptionsEngine::Configuration.new }

    describe "#service_name" do
      it "defaults to a value" do
        expect(configuration.service_name).to eq("Waste Exemptions Service")
      end

      it "can be overridden" do
        configuration.service_name = "Awesome Exemptions Service"
        expect(configuration.service_name).to eq("Awesome Exemptions Service")
      end
    end

    describe "#years_before_expiry" do
      it "defaults to a value" do
        expect(configuration.years_before_expiry).to eq(3)
      end

      it "can be overridden" do
        configuration.service_name = 5
        expect(configuration.service_name).to eq(5)
      end
    end

    describe "#use_xvfb_for_wickedpdf" do
      it "defaults to a value" do
        expect(configuration.use_xvfb_for_wickedpdf).to eq("true")
      end

      it "can be overridden" do
        configuration.service_name = "false"
        expect(configuration.service_name).to eq("false")
      end
    end
  end
end
