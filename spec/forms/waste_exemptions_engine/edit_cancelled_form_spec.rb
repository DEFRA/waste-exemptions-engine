# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe EditCancelledForm, type: :model do
    subject(:form) { build(:edit_cancelled_form) }

    describe "#submit" do
      it "raises an error" do
        expect { form.submit({}) }.to raise_error(UnsubmittableForm)
      end
    end
  end
end
