# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Declaration Forms" do

    # Commenting out this spec to avoid a direct conflict:
    # - Govuk formbuilder explicitly adds 'type="hidden" value="0" autocomplete="off"' for a single checkbox
    #   ref: https://govuk-form-builder.netlify.app/form-elements/checkboxes/#output-html-generating-a-single-checkbox
    # - However has_valid_html explicitly complains about this:
    #   'An “input” element with a “type” attribute whose value is “hidden” must not have an “autocomplete” attribute whose value is “on” or “off”.'
    # It is not clear when this incompatability arose.  For now we rely on DR and QA to ensure valid HTML.
    # TODO: Reinstate this spec when the conflict between the gems has been resolved.
    # include_examples "GET form", :declaration_form, "/declaration"

    include_examples "POST form", :declaration_form, "/declaration" do
      let(:form_data) { { declaration: 1 } }
      let(:invalid_form_data) { [{ declaration: 0 }] }
    end
  end
end
