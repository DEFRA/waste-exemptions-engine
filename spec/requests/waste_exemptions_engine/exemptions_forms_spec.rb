# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Exemptions Forms", type: :request do
    include_examples "GET form", :exemptions_form, "/exemptions"
    include_examples "go back", :exemptions_form, "/exemptions/back"
    include_examples "POST form", :exemptions_form, "/exemptions" do
      let(:form_data) { { exemptions: create_list(:exemption, 10).map(&:id).map(&:to_s) } }
    end
  end
end
