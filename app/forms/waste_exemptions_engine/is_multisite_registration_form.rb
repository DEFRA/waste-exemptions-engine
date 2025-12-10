# frozen_string_literal: true

module WasteExemptionsEngine
  class IsMultisiteRegistrationForm < BaseForm
    delegate :is_multisite_registration, to: :transient_registration

    validates :is_multisite_registration, "defra_ruby/validators/true_false": true

    def submit(attributes)
      # Single-site and multisite are different application types.
      # Reset site addresses when changing selection to avoid inconsistent state.
      transient_registration.transient_addresses.where(address_type: "site").destroy_all

      super
    end

    def minimum_sites_required
      WasteExemptionsEngine::CanHaveMultipleSites.minimum_sites_required
    end
  end
end
