# frozen_string_literal: true

module WasteExemptionsEngine
  class NewRegistration < TransientRegistration
    include CanUseNewRegistrationWorkflow

    after_create :apply_reference

    private

    def apply_reference
      self.reference = format("WEX%06d", id)
      save!
    end
  end
end
