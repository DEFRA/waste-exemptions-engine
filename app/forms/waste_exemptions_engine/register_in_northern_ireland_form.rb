# frozen_string_literal: true

module WasteExemptionsEngine
  class RegisterInNorthernIrelandForm < BaseForm
    include CanNavigateFlexibly

    def initialize(transient_registration)
      super
    end

    # Override BaseForm method as users shouldn't be able to submit this form
    def submit; end
  end
end
