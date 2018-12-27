# frozen_string_literal: true

module WasteExemptionsEngine
  class ContactPostcodeForm < PostcodeForm
    include CanNavigateFlexibly

    attr_accessor :business_type, :contact_postcode

    def initialize(enrollment)
      super

      self.contact_postcode = @enrollment.interim.contact_postcode
    end

    def submit(params)
      # Assign the params for validation and pass them to the BaseForm method
      # for updating
      self.contact_postcode = params[:contact_postcode]
      format_postcode(contact_postcode)
      attributes = {}

      # While we won't proceed if the postcode isn't valid, we should always
      # save it in case it's needed for manual entry
      @enrollment.interim.update_attributes(contact_postcode: contact_postcode)

      super(attributes, params[:token])
    end

    validates :contact_postcode, "waste_exemptions_engine/postcode": true
  end
end
