# frozen_string_literal: true

module WasteExemptionsEngine
  class BaseForm
    include ActiveModel::Model
    include CanStripWhitespace

    attr_accessor :token, :transient_registration

    def initialize(registration)
      # Get values from registration so form will be pre-filled
      @transient_registration = registration
      self.token = @transient_registration.token
    end

    def submit(attributes, token)
      # Additional attributes are set in individual form subclasses
      self.token = token

      attributes = strip_whitespace(attributes)

      # Update the registration with params from the registration if valid
      if valid?
        @transient_registration.update_attributes(attributes)
        @transient_registration.save!
        true
      else
        false
      end
    end

    # If the record is new, and not yet persisted (which it is when the start
    # page is first submitted) then we have nothing to validate hence the check
    validates :token, "waste_exemptions_engine/token": true if @transient_registration&.persisted?
    validate :registration_valid?

    private

    def registration_valid?
      return if @transient_registration.valid?

      @transient_registration.errors.each do |_attribute, message|
        errors[:base] << message
      end
    end
  end
end
