# frozen_string_literal: true

require "rails_helper"

module Test
  WasteActivitiesValidatable = Struct.new(:waste_activities) do
    include ActiveModel::Validations

    validates :waste_activities, "waste_exemptions_engine/waste_activities": true
  end
end

module WasteExemptionsEngine
  RSpec.describe WasteActivitiesValidator, type: :model do
    valid_waste_activities = %w[1 6 12]

    # Since valid_waste_activities is an Array we need to wrap it in another Array to avoid treating
    # the argument like a set of multiple arguments.
    it_behaves_like "a validator", Test::WasteActivitiesValidatable, :waste_activities, [valid_waste_activities]

    describe "#validate_each" do
      context "when the waste_activities selection is not valid" do
        context "when the waste_activities are not present" do
          validatable = Test::WasteActivitiesValidatable.new
          error_message = Helpers::Translator.error_message(validatable, :waste_activities, :inclusion)

          it_behaves_like "an invalid record", validatable, :waste_activities, error_message
        end

        context "when the waste_activities are empty" do
          validatable = Test::WasteActivitiesValidatable.new([])
          error_message = Helpers::Translator.error_message(validatable, :waste_activities, :inclusion)

          it_behaves_like "an invalid record", validatable, :waste_activities, error_message
        end
      end
    end
  end
end
