# frozen_string_literal: true

module WasteExemptionsEngine
  class EditCancellationService < BaseService
    def run(edit_registration:)
      @edit_registration = edit_registration
      @edit_registration.destroy
    end
  end
end
