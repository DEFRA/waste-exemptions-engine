# frozen_string_literal: true

require "rails_helper"

module Test
  YesNoValidatable = Struct.new(:boolean_response) do
    include ActiveModel::Validations

    validates :boolean_response, "waste_exemptions_engine/yes_no": true
  end
end

module WasteExemptionsEngine
  RSpec.describe YesNoValidator, type: :model do
    valid_response = %w[true false].sample

    it_behaves_like "a validator", Test::YesNoValidatable, :boolean_response, valid_response
    it_behaves_like "a selection validator", Test::YesNoValidatable, :boolean_response
  end
end
