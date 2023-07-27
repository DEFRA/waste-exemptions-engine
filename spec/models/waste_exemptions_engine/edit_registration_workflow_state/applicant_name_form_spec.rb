# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe EditRegistration do
    describe "#workflow_state" do
      it_behaves_like "a simple monodirectional transition",
                      previous_and_next_state: :back_office_edit_form,
                      current_state: :applicant_name_form,
                      factory: :edit_registration
    end
  end
end
