# frozen_string_literal: true

module WasteExemptionsEngine
  class CheckYourAnswersFormsController < FormsController
    def new
      super(CheckYourAnswersForm, "check_your_answers_form")
    end

    def create
      super(CheckYourAnswersForm, "check_your_answers_form")
    end

    def edit_contact_name
      transition_to_edit("edit_contact_name")
    end

    private

    def transition_to_edit(transition)
      find_or_initialize_registration(params[:token])

      @transient_registration.update(
        temp_check_your_answers_flow: true,
        workflow_history: @transient_registration.workflow_history << "check_your_answers_form"
      )

      @transient_registration.send(:"#{transition}!")
      redirect_to_correct_form
    end
  end
end
