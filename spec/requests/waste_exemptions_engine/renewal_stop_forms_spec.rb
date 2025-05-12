# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Renewal Stop Forms" do
    let(:form) { build(:renewal_stop_form) }

    it_behaves_like "GET form", :renewal_stop_form, "/renewal-stop"
    it_behaves_like "unable to POST form", :renewal_stop_form, "/renewal-stop"
  end
end
