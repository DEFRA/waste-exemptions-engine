# frozen_string_literal: true

module WasteExemptionsEngine
  class CharitablePurposeForm < BaseForm
    delegate :charitable_purpose, to: :transient_registration

    validates :charitable_purpose, "defra_ruby/validators/true_false": true
  end
end
