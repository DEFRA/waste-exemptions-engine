# frozen_string_literal: true

module WasteExemptionsEngine
  class IsMultisiteRegistrationForm < BaseForm
    delegate :is_multisite_registration, to: :transient_registration

    validates :is_multisite_registration, "defra_ruby/validators/true_false": true
  end
end
