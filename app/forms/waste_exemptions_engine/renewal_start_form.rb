# frozen_string_literal: true

module WasteExemptionsEngine
  class RenewalStartForm < BaseForm
    attr_accessor :temp_renew_without_changes

    def initialize(registration)
      super
      self.temp_renew_without_changes = @transient_registration.temp_renew_without_changes
    end

    def submit(params)
      # Assign the params for validation and pass them to the BaseForm method for updating
      self.temp_renew_without_changes = params[:temp_renew_without_changes]
      attributes = { temp_renew_without_changes: temp_renew_without_changes }

      super(attributes, params[:token])
    end

    validates :temp_renew_without_changes, "defra_ruby/validators/true_false": true
  end
end
