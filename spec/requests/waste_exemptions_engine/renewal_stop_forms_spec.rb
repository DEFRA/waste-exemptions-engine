# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Renewal Stop Forms" do
    let(:form) { build(:renewal_stop_form) }

    include_examples "GET form", :renewal_stop_form, "/renewal-stop"
    include_examples "unable to POST form", :renewal_stop_form, "/renewal-stop"
  end
end
