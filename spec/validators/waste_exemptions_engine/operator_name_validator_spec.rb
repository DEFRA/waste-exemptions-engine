# frozen_string_literal: true

require "rails_helper"

module Test
  OperatorNameValidatable = Struct.new(:operator_name) do
    include ActiveModel::Validations

    validates :operator_name, "waste_exemptions_engine/operator_name": true
  end
end

module WasteExemptionsEngine
  RSpec.describe OperatorNameValidator, type: :model do
    valid_name = "Acme Waste Management"
    too_long_name = Helpers::TextGenerator.random_string(256) # The max length is 255.

    it_behaves_like "a validator", Test::OperatorNameValidatable, :operator_name, valid_name
    it_behaves_like "a presence validator", Test::OperatorNameValidatable, :operator_name
    it_behaves_like "a length validator", Test::OperatorNameValidatable, :operator_name, too_long_name
  end
end
