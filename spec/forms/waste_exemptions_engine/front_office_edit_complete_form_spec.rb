# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe FrontOfficeEditCompleteForm, type: :model do
    subject(:form) { build(:front_office_edit_complete_form) }

    describe "#submit" do
      it "raises an error" do
        expect { form.submit({}) }.to raise_error(UnsubmittableForm)
      end
    end
  end
end
