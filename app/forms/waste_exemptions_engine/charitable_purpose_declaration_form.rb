# frozen_string_literal: true

module WasteExemptionsEngine
  class CharitablePurposeDeclarationForm < BaseForm
    delegate :charitable_purpose_declaration, to: :transient_registration

    validates :charitable_purpose_declaration, inclusion: { in: [true] }

    def self.can_navigate_flexibly?
      false
    end
  end
end
