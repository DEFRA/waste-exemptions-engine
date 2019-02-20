# frozen_string_literal: true

require "rails_helper"

module Test
  StartValidatable = Struct.new(:start) do
    include ActiveModel::Validations

    validates :start, "waste_exemptions_engine/start": true
  end
end

module WasteExemptionsEngine
  RSpec.describe StartValidator, type: :model do
    valid_start = %w[new reregister change].sample

    it_behaves_like "a validator", Test::StartValidatable, :start, valid_start
    it_behaves_like "a selection validator", Test::StartValidatable, :start
  end
end
