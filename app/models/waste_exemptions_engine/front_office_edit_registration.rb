# frozen_string_literal: true

module WasteExemptionsEngine
  class FrontOfficeEditRegistration < TransientRegistration
    include CanUseFrontOfficeEditRegistrationWorkflow
    include CanCopyDataFromRegistration

    def modified?(ignore_exemptions: false)
      return true if !ignore_exemptions && exemptions_modified?
      return true if contact_address_modified?

      %i[
        contact_first_name
        contact_last_name
        contact_phone
        contact_email
      ].any? do |attr|
        send(attr) != registration.send(attr)
      end
    end

    private

    def exemptions_modified?
      exemptions.pluck(:id).sort != registration.exemptions.pluck(:id).sort
    end

    def contact_address_modified?
      attributes = %w[uprn
                      organisation
                      premises
                      street_address
                      locality
                      city
                      postcode]
      contact_address.attributes.slice(*attributes) != registration.contact_address.attributes.slice(*attributes)
    end

    def default_workflow_state
      "front_office_edit_form"
    end
  end
end
