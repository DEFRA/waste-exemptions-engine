# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Exemptions Forms", type: :request do
    before(:context) do
      WasteExemptionsEngine::Exemption.delete_all
      create_list(:exemption, 5)
    end

    include_examples "GET form", :exemptions_form, "/exemptions"
    include_examples "POST form", :exemptions_form, "/exemptions" do
      let(:form_data) { { exemption_ids: Exemption.limit(5).pluck(:id) } }
      let(:invalid_form_data) { [{ exemption_ids: [] }] }
    end
  end
end
