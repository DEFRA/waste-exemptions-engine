# frozen_string_literal: true

module WasteExemptionsEngine
  class IsAFarmerForm < BaseForm
    delegate :is_a_farmer, to: :transient_registration

    validates :is_a_farmer, "defra_ruby/validators/true_false": true
  end
end
