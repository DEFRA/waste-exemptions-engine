# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe RenewWithoutChangesForm, type: :model do
    subject(:form) { build(:renew_without_changes_form) }

    let(:transient_registration) { form.transient_registration }

    let(:valid_params) { {} }

    before do
      transient_registration.registration_exemptions = []
      transient_registration.save!
      transient_registration.reload
    end

    it "maintains the correct exemptions when renewing" do
      expect(transient_registration.exemptions).to be_empty # sanity

      form.submit(valid_params)

      transient_registration.reload

      expect(transient_registration.exemptions).not_to be_empty

      expect(transient_registration.exemptions.map(&:id))
        .to eq(transient_registration.referring_registration.exemptions.map(&:id))
    end
  end
end
