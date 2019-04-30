# frozen_string_literal: true

module WasteExemptionsEngine
  class EditFormsController < FormsController
    helper EditHelper

    def new
      super(EditForm, "edit_form")
    end

    def create
      super(EditForm, "edit_form")
    end

    def edit_location
      transition_to_edit("edit_location")
    end

    def edit_applicant_name
      transition_to_edit("edit_applicant_name")
    end

    def edit_applicant_phone
      transition_to_edit("edit_applicant_phone")
    end

    def edit_applicant_email
      transition_to_edit("edit_applicant_email")
    end

    def edit_main_people
      transition_to_edit("edit_main_people")
    end

    def edit_registration_number
      transition_to_edit("edit_registration_number")
    end

    def edit_operator_name
      transition_to_edit("edit_operator_name")
    end

    def edit_operator_postcode
      transition_to_edit("edit_operator_postcode")
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

    def edit_on_a_farm
      transition_to_edit("edit_on_a_farm")
    end

    def edit_is_a_farmer
      transition_to_edit("edit_is_a_farmer")
    end

    def edit_site_grid_reference
      transition_to_edit("edit_site_grid_reference")
    end

    def cancel
      find_or_initialize_registration(params[:token])
      @transient_registration.cancel_edit!
      redirect_to_correct_form
    end

    private

    def find_or_initialize_registration(token)
      if /^WEX/.match?(token)
        find_or_initialize_edited_registration(token)
      else
        super
      end
    end

    def find_or_initialize_edited_registration(reference)
      @transient_registration = EditRegistration.where(
        reference: reference
      ).first || EditRegistration.new(reference: reference)
    end

    def transition_to_edit(transition)
      find_or_initialize_registration(params[:token])
      @transient_registration.send("#{transition}!".to_sym)
      redirect_to_correct_form
    end
  end
end
