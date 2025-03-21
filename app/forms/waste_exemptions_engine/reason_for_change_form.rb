# frozen_string_literal: true

module WasteExemptionsEngine
  class ReasonForChangeForm < BaseForm
    delegate :reason_for_change, to: :transient_registration

    validates :reason_for_change, presence: true, length: { maximum: 500 }

    def self.can_navigate_flexibly?
      false
    end
  end
end
