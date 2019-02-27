# frozen_string_literal: true

module WasteExemptionsEngine
  class RegisterInWalesForm < BaseForm
    include CanNavigateFlexibly

    def initialize(registration)
      super
    end

    # Override BaseForm method as users shouldn't be able to submit this form
    def submit; end
  end
end
