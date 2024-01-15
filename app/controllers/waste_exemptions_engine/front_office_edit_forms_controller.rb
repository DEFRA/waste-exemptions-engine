# frozen_string_literal: true

module WasteExemptionsEngine
  class FrontOfficeEditFormsController < FormsController
    helper EditHelper

    def new
      super(FrontOfficeEditForm, "front_office_edit_form")
    end

    def create
      super(FrontOfficeEditForm, "front_office_edit_form")
    end

    def edit_exemptions
      transition_to_edit("edit_exemptions")
    end

    def edit_contact_name
      transition_to_edit("edit_contact_name")
    end

    def edit_contact_phone
      transition_to_edit("edit_contact_phone")
    end

    def edit_contact_email
      transition_to_edit("edit_contact_email")
    end

    def edit_contact_postcode
      transition_to_edit("edit_contact_postcode")
    end

    def validate_edit_token
      return render(:invalid_edit_link, status: 404) unless registration.present?
      # return 404 for an expired token as WAF is configured to not allow 422 responses:
      return render(:edit_link_expired, status: 404) if token_expired?

      @transient_registration = FrontOfficeEditRegistration.find_or_create_by(reference: registration.reference)
      @transient_registration.aasm.enter_initial_state

      redirect_to_correct_form
    end

    private

    def registration
      @registration ||= Registration.where(edit_token: params[:edit_token].split("/")[0]).first
    end

    def token_expired?
      return false unless @registration.present?

      @registration.edit_token_created_at < ENV.fetch("EDIT_TOKEN_VALIDITY_HOURS", 48).to_i.hours.ago
    end

    def transition_to_edit(transition)
      find_or_initialize_registration(params[:token])

      @transient_registration.send(:"#{transition}!")
      redirect_to_correct_form
    end
  end
end
