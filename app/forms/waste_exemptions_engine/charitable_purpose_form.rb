# frozen_string_literal: true

module WasteExemptionsEngine
  class CharitablePurposeForm < BaseForm
    delegate :charitable_purpose, to: :transient_registration

    validates :charitable_purpose, "defra_ruby/validators/true_false": true

    def submit(attributes)
      @transient_registration.charitable_purpose_declaration = false if attributes[:charitable_purpose] == "false"

      super
    end
  end
end
