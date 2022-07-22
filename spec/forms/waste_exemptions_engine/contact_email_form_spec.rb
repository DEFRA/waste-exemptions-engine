# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe ContactEmailForm, type: :model do
    it_behaves_like "an optional email form", :contact_email_form, :contact_email
  end
end
