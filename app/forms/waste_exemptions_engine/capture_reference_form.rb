# frozen_string_literal: true

module WasteExemptionsEngine
  class CaptureReferenceForm < BaseForm
    delegate :reference, to: :transient_registration

    validates_with RegistrationLookupValidator

    def submit(params)
      params[:reference]&.upcase!

      super
    end
  end
end
