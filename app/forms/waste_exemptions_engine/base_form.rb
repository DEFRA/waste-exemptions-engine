# frozen_string_literal: true

module WasteExemptionsEngine
  class BaseForm
    include ActiveModel::Model
    include CanStripWhitespace

    attr_accessor :token, :enrollment

    def initialize(enrollment)
      # Get values from enrollment so form will be pre-filled
      @enrollment = enrollment
      self.token = @enrollment.token
    end

    def submit(attributes, token)
      # Additional attributes are set in individual form subclasses
      self.token = token

      attributes = strip_whitespace(attributes)

      # Update the enrollment with params from the registration if valid
      if valid?
        @enrollment.update_attributes(attributes)
        @enrollment.save!
        true
      else
        false
      end
    end

    # If the record is new, and not yet persisted (which it is when the start
    # page is first submitted) then we have nothing to validate hence the check
    validates :token, "waste_exemptions_engine/token": true if @enrollment&.persisted?
    validate :enrollment_valid?

    private

    def enrollment_valid?
      return if @enrollment.valid?

      @enrollment.errors.each do |_attribute, message|
        errors[:base] << message
      end
    end
  end
end
