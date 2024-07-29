# frozen_string_literal: true

module WasteExemptionsEngine
  class RenewalStartFormsController < FormsController
    def new
      super(RenewalStartForm, "renewal_start_form")
    end

    def create
      super(RenewalStartForm, "renewal_start_form")
    end

    def edit_exemptions
      transition_to_edit("edit_exemptions")
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

    def edit_contact_address
      transition_to_edit("edit_contact_address")
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

    def edit_contact_position
      transition_to_edit("edit_contact_position")
    end

    def edit_on_a_farm
      transition_to_edit("edit_on_a_farm")
    end

    def edit_is_a_farmer
      transition_to_edit("edit_is_a_farmer")
    end

    def edit_operator_address
      transition_to_edit("edit_operator_address")
    end

    private

    def transient_registration_attributes
      params.fetch(:renewal_start_form, {}).permit(:temp_renew_without_changes)
    end

    def transition_to_edit(transition)
      find_or_initialize_registration(params[:token])

      check_your_answers_edit_mode(true)
      add_to_history("renewal_start_form")

      @transient_registration.send(:"#{transition}!")
      redirect_to_correct_form
    end

    def check_your_answers_edit_mode(true_or_false)
      find_or_initialize_registration(params[:token])
      @transient_registration.update(temp_check_your_answers_flow: true_or_false)
    end

    def add_to_history(form_name)
      find_or_initialize_registration(params[:token])
      @transient_registration.update(
        workflow_history: @transient_registration.workflow_history << form_name
      )
    end
  end
end
