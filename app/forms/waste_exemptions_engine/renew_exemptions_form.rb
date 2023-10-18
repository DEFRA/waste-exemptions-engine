# frozen_string_literal: true

module WasteExemptionsEngine
  class RenewExemptionsForm < BaseForm
    delegate :exemptions, to: :transient_registration
    delegate :referring_registration, to: :transient_registration
  end
end
