# frozen_string_literal: true

module WasteExemptionsEngine
  class CheckYourAnswersFormsController < FormsController
    def new
      check_your_answers_edit_mode(false)
      super(CheckYourAnswersForm, "check_your_answers_form")
    end

    def create
      super(CheckYourAnswersForm, "check_your_answers_form")
    end

    def edit_contact_name
      transition_to_edit("edit_contact_name")
    end

    def edit_operator_name
      transition_to_edit("edit_operator_name")
    end

    private

    def transition_to_edit(transition)
      find_or_initialize_registration(params[:token])

      check_your_answers_edit_mode(true)
      add_to_history("check_your_answers_form")

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
