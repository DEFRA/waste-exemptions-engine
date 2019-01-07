# frozen_string_literal: true

module WasteExemptionsEngine
  class DeclarationForm < BaseForm
    include CanNavigateFlexibly

    attr_accessor :declaration

    def initialize(registration)
      super
      self.declaration = @registration.declaration
    end

    def submit(params)
      self.declaration = params[:declaration].to_i

      attributes = { declaration: declaration }

      super(attributes, params[:token])
    end

    validates :declaration, inclusion: { in: [1] }
  end
end
