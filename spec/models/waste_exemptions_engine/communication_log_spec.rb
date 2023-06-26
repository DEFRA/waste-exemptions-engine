# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe CommunicationLog do
    describe "public interface" do
      subject(:communication_log) { build(:communication_log) }

      associations = [:registration]

      (Helpers::ModelProperties::COMMUNICATION_LOG + associations).each do |property|
        it "responds to property" do
          expect(communication_log).to respond_to(property)
        end
      end
    end
  end
end
