# frozen_string_literal: true

module WasteExemptionsEngine
  class PostcodeForm < BaseForm

    attr_accessor :postcode

    def initialize(enrollment)
      super

      self.postcode = existing_postcode
    end

    def submit(params)
      # Assign the params for validation and pass them to the BaseForm method
      # for updating
      self.postcode = params[:postcode]
      format_postcode

      # While we won't proceed if the postcode isn't valid, we should always
      # save it in case it's needed for manual entry
      interim_field = determine_interim_postcode_field_name
      @enrollment.interim.update_attributes(interim_field => postcode)

      # We pass through an empty hash for the attributes, as there is nothing to
      # update on the enrollment itself
      super({}, params[:token])
    end

    validates :postcode, "waste_exemptions_engine/postcode": true

    private

    def format_postcode
      return unless postcode.present?

      postcode.upcase!
      postcode.strip!
    end

    # We use this to work out what the field name will be in the interim model.
    # It relies on the convention of naming the field object_postcde e.g.
    # contact_postcode, and that the form object will also correspond to this
    # e.g. ContactPostcodeForm
    # By doing this we can remove duplication in the postcode form objects
    # which previously only needed a different submit method in order to specify
    # the name of the field to update.
    def determine_interim_postcode_field_name
      name = self.class.name.demodulize
      name.sub!("Form", "")
      name.underscore.to_sym
    end

    def existing_postcode
      raise NotImplementedError, "This #{self.class} cannot respond to:"
    end
  end
end
