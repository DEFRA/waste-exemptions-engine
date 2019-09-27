# frozen_string_literal: true

module WasteExemptionsEngine
  class DeclarationForm < BaseForm
    delegate :declaration, to: :transient_registration

    validates :declaration, inclusion: { in: [1] }

    def self.can_navigate_flexibly?
      false
    end

    def submit(params)
      attributes = { declaration: params[:declaration].to_i }

      super(attributes)
    end
  end
end
