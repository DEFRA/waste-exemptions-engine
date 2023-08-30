# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Front Office Edit Declaration Forms" do
    let(:form) { build(:front_office_edit_declaration_form) }

    include_examples "GET form", :front_office_edit_declaration_form, "/front-office-edit-declaration"

    include_examples "POST form", :front_office_edit_declaration_form, "/front-office-edit-declaration" do
      let(:form_data) { { declaration: 1 } }
      let(:invalid_form_data) { [{ declaration: 0 }] }
    end
  end
end
