# frozen_string_literal: true

module WasteExemptionsEngine
  class AddressManualForm < BaseForm
    include AddressForm

    attr_accessor :address_finder_error
    attr_accessor :premises, :street_address, :locality, :city

    def initialize(enrollment)
      super

      self.postcode = existing_postcode

      # Check if the user reached this page through an Address finder error.
      # Then wipe the temp attribute as we only need it for routing
      self.address_finder_error = @enrollment.interim.address_finder_error
      @enrollment.interim.update_attributes(address_finder_error: nil)

      # Prefill the existing address unless the postcode has changed from the existing address's postcode
      prefill_existing_address if saved_address_still_valid?
    end

    def submit(params)
      # Strip out whitespace from start and end
      params.each { |_key, value| value.strip! }
      # Assign the params for validation and pass them to the BaseForm method for updating
      self.premises = params[:premises]
      self.street_address = params[:street_address]
      self.locality = params[:locality]
      self.city = params[:city]
      self.postcode = params[:postcode]

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
      new_address = create_address(
        premises: premises,
        street_address: street_address,
        locality: locality,
        city: city,
        postcode: postcode
      )

      attributes = { addresses: add_or_replace_address(new_address, @enrollment.addresses) }

      super(attributes, params[:token])
    end

    validates :premises, presence: true, length: { maximum: 200 }
    validates :street_address, presence: true, length: { maximum: 160 }
    validates :locality, length: { maximum: 70 }
    validates :city, presence: true, length: { maximum: 30 }
    validates :postcode, length: { maximum: 8 }

    private

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

    def create_address(params)
      Address.create_from_manual_entry_data(
        params,
        address_type
      )
    end
  end
end
