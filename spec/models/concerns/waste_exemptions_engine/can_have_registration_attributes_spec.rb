# frozen_string_literal: true

require "rails_helper"

class TestRegistrationClass
  include WasteExemptionsEngine::CanHaveRegistrationAttributes

  attr_accessor :is_a_farmer, :on_a_farm

  def initialize(is_a_farmer:, on_a_farm:)
    @is_a_farmer = is_a_farmer
    @on_a_farm = on_a_farm
  end

  def is_a_farmer?
    is_a_farmer
  end

  def on_a_farm?
    on_a_farm
  end
end

module WasteExemptionsEngine
  RSpec.describe CanHaveRegistrationAttributes do

    subject(:registration) { TestRegistrationClass.new(is_a_farmer:, on_a_farm:) }

    describe "#farm_affiliated?" do
      context "when the registration is not for a farmer" do
        let(:is_a_farmer) { false }

        context "when the registration is not on a farm" do
          let(:on_a_farm) { false }

          it { expect(registration.farm_affiliated?).to be false }
        end

        context "when the registration is on a farm" do
          let(:on_a_farm) { true }

          it { expect(registration.farm_affiliated?).to be false }
        end
      end

      context "when the registration is for a farmer" do
        let(:is_a_farmer) { true }

        context "when the registration is not on a farm" do
          let(:on_a_farm) { false }

          it { expect(registration.farm_affiliated?).to be false }
        end

        context "when the registration is on a farm" do
          let(:on_a_farm) { true }

          it { expect(registration.farm_affiliated?).to be true }
        end
      end
    end
  end
end
