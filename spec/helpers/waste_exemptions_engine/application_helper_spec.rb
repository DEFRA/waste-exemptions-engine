# frozen_string_literal: true

require "rails_helper"

RSpec.describe WasteExemptionsEngine::ApplicationHelper, type: :helper do
  describe "#format_names" do
    it "concatenates first and last name into a full name" do
      expect(helper.format_names("Fiona", "Laurel")).to eq("Fiona Laurel")
    end
  end
end
