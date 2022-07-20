# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe ApplicantEmailForm, type: :model do
    it_behaves_like "an optional email form", :applicant_email_form, :applicant_email
  end
end
