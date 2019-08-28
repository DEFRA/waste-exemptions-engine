# frozen_string_literal: true

module WasteExemptionsEngine
  class DeclarationForm < BaseForm
    attr_accessor :declaration

    validates :declaration, inclusion: { in: [1] }

    def self.can_navigate_flexibly?
      false
    end

    def initialize(registration)
      super
      self.declaration = @transient_registration.declaration
    end

    def submit(params)
      self.declaration = params[:declaration].to_i

      attributes = { declaration: declaration }

      super(attributes)
    end
  end
end
