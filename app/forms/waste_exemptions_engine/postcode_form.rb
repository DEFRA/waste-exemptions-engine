# frozen_string_literal: true

module WasteExemptionsEngine
  class PostcodeForm < BaseForm
    include CanSetPostcode

    def submit(params)
      # Assign the params for validation and pass them to the BaseForm method
      # for updating
      self.postcode = format_postcode(params[:postcode])

      # While the postcode may not be valid, we always save it in case it's
      # needed for manual entry
      temp_field = determine_temp_postcode_field_name
      @transient_registration.update_attributes(temp_field => postcode)

      # We pass through an empty hash for the attributes, as there is nothing to
      # update on the registration itself
      super({}, params[:token])
    end

    validates :postcode, "waste_exemptions_engine/postcode": true

    def address_finder_error(error_occurred)
      transient_registration.address_finder_error = error_occurred
    end

    private

    def format_postcode(postcode)
      return unless postcode.present?

      postcode.upcase.strip
    end

    # We use this to work out what the temp field name will be in the model.
    # It relies on the convention of naming the field temp_object_postcode e.g.
    # temp_contact_postcode, and that the form object will also correspond to
    # this e.g. ContactPostcodeForm
    # By doing this we can remove duplication in the postcode form objects
    # which previously had a different submit method just because they needed
    # to specify the name of the field to update.
    def determine_temp_postcode_field_name
      name = self.class.name.demodulize
      name.sub!("Form", "")
      "temp_#{name.underscore}".to_sym
    end

    def existing_postcode
      raise NotImplementedError, "This #{self.class} cannot respond to:"
    end
  end
end
