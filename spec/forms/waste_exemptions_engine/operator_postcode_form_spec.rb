# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe OperatorPostcodeForm, type: :model do
    it_behaves_like "a postcode form", :operator_postcode_form
  end
end
