# frozen_string_literal: true

module WasteExemptionsEngine
  class AddressManualForm < BaseForm
    include CanAddOrReplaceAnAddress

    attr_accessor :address_finder_error
    attr_accessor :premises, :street_address, :locality, :city, :postcode

    validates_with LegacyManualAddressValidator

    def initialize(registration)
      super

      self.postcode = existing_postcode

      # Check if the user reached this page through an Address finder error.
      # Then wipe the temp attribute as we only need it for routing
      self.address_finder_error = @transient_registration.address_finder_error
      @transient_registration.update_attributes(address_finder_error: nil)

      # Prefill the existing address unless the postcode has changed from the existing address's postcode
      prefill_existing_address if saved_address_still_valid?
    end

    def submit(params)
      assign_params(params)

      new_address = create_address if valid?

      attributes = {
        transient_addresses: add_or_replace_address(
          new_address,
          @transient_registration.transient_addresses,
          existing_address
        )
      }

      super(attributes)
    end

    private

    def assign_params(params)
      # Assign the params for validation and pass them to the BaseForm method for updating
      self.premises = params[:premises]&.strip
      self.street_address = params[:street_address]&.strip
      self.locality = params[:locality]&.strip
      self.city = params[:city]&.strip
      self.postcode = params[:postcode]&.strip
    end

    def saved_address_still_valid?
      return false unless existing_address
      return true if postcode.blank?
      return true if postcode == existing_address.postcode

      false
    end

    def prefill_existing_address
      return unless existing_address

      self.premises = existing_address.premises
      self.street_address = existing_address.street_address
      self.locality = existing_address.locality
      self.city = existing_address.city
      self.postcode = existing_address.postcode
    end

    def create_address
      # Now that we are dealing with Activerecord it has protections in place to
      # stop us mass assigning attributes on a model that come direct from the
      # params object. In a typical rails project you would have a method in your
      # controller in which you would call
      # params.require(:my_model).permit!(:email, :amount, :paid). This does also
      # work with form objects (just replace my_model for my_form) however it
      # assumes we are passing the data to the object via calling the method e.g.
      # @my_form = MyForm.new(sanitize_params)
      # For the following reasons we have chosen instead to simply assign the
      # attributes in the way below because
      #   - the complexity of the form->sub-form->base-form relationship we have
      #     in this instance
      #   - attempting to follow the pattern could lead to a refactor of the
      #     underlying base form objects and controllers
      #   - the manual address is the only instance we have of mass assigning
      #     params to a model
      TransientAddress.create_from_manual_entry_data(
        {
          premises: premises,
          street_address: street_address,
          locality: locality,
          city: city,
          postcode: postcode
        },
        address_type
      )
    end
  end
end
