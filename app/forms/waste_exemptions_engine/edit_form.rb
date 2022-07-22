# frozen_string_literal: true

module WasteExemptionsEngine
  class EditForm < BaseForm
    include DataOverviewForm

    delegate :reference, :company_no_required?, to: :transient_registration

    after_initialize :persist_registration

    private

    def persist_registration
      transient_registration.save! unless transient_registration.persisted?
    end
  end
end
