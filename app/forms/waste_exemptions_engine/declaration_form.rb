# frozen_string_literal: true

module WasteExemptionsEngine
  class DeclarationForm < BaseForm
    attr_accessor :declaration

    set_callback :initialize, :after, :set_declaration

    def self.can_navigate_flexibly?
      false
    end

    def submit(params)
      self.declaration = params[:declaration].to_i

      attributes = { declaration: declaration }

      super(attributes)
    end

    validates :declaration, inclusion: { in: [1] }

    private

    def set_declaration
      self.declaration = @transient_registration.declaration
    end
  end
end
