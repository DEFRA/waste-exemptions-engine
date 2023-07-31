# frozen_string_literal: true

module WasteExemptionsEngine
  class RegistrationLookupForm < BaseForm
    delegate :reference, to: :transient_registration

    validates_with RegistrationLookupValidator

    def submit(params)
      params[:reference]&.upcase!

      super
    end
  end
end
