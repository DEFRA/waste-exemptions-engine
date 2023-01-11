# frozen_string_literal: true

module WasteExemptionsEngine
  class RenewWithoutChangesForm < BaseForm
    def submit(_params)
      # When a user first renews with changes and deselects some or all
      # exemptions to renew and subsequently navigates back to renew without
      # changes we run into an edge case where exemptions do not match the
      # referring registration.  We re-assign these exemptions here to
      # correctly renew the registration.
      transient_registration.exemptions =
        transient_registration.registration_exemptions_to_copy

      super({})
    end
  end
end
