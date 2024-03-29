# frozen_string_literal: true

module WasteExemptionsEngine
  class EditExemptionsDeclarationForm < BaseForm
    delegate :declaration, to: :transient_registration

    validates :declaration, inclusion: { in: [true] }

    def self.can_navigate_flexibly?
      false
    end
  end
end
