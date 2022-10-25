# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Cannot renew type change" do
    include_examples "GET form", :cannot_renew_type_change_form, "/cannot-renew-type-change"
    include_examples "unable to POST form", :cannot_renew_type_change_form, "/cannot-renew-type-change"
  end
end
