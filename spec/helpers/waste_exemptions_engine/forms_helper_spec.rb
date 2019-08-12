# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe FormsHelper, type: :helper do
    describe "data_layer" do
      it "returns the correct value" do
        expect(helper.data_layer).to eq({})
      end
    end
  end
end
