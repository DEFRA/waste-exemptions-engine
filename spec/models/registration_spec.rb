# frozen_string_literal: true

require "rails_helper"

RSpec.describe WasteExemptionsEngine::Registration, type: :model do
  describe "scope" do
    it_should_behave_like "Registration scopes"
  end
end
