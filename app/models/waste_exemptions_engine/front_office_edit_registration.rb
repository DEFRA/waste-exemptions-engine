# frozen_string_literal: true

module WasteExemptionsEngine
  class FrontOfficeEditRegistration < TransientRegistration
    include CanUseFrontOfficeEditRegistrationWorkflow
    include CanCopyDataFromRegistration

    def modified?
      return true if exemptions_modified?
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
      contact_address&.postcode != registration.contact_address&.postcode \
      || contact_address&.uprn != registration.contact_address&.uprn
    end

    def default_workflow_state
      "front_office_edit_form"
    end
  end
end
