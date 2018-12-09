# frozen_string_literal: true

module WasteExemptionsEngine
  class BaseForm
    include ActiveModel::Model
    include CanStripWhitespace

    attr_accessor :id, :enrollment

    def initialize(enrollment)
      # Get values from enrollment so form will be pre-filled
      @enrollment = enrollment
      self.id = @enrollment.id
    end

    def submit(attributes, id)
      # Additional attributes are set in individual form subclasses
      self.id = id

      attributes = strip_whitespace(attributes)

      # Update the transient registration with params from the registration if valid
      if valid?
        @enrollment.update_attributes(attributes)
        @enrollment.save!
        true
      else
        false
      end
    end

    validates :id, "waste_exemptions_engine/id": true
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
