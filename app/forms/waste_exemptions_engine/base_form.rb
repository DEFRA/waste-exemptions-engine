# frozen_string_literal: true

module WasteExemptionsEngine
  class BaseForm
    include ActiveModel::Model
    extend ActiveModel::Callbacks

    include CanStripWhitespace

    # The standard behaviour for loading a form is to check whether the requested form matches the workflow_state for
    # the registration, and redirect to the saved workflow_state if it doesn't.
    # But if the workflow state is 'flexible', we skip the check and load the requested form instead of the saved one.
    # This means users can still navigate by using the browser back button and reload forms which don't match the
    # saved workflow_state. We then update the workflow_state to match their request, rather than the other way around.
    # These are generally forms after 'start_form' but before 'declaration_form'.
    # Any form objects including this concern are considered to be 'flexible' by the FormsController.
    def self.can_navigate_flexibly?
      # This can be overriden in a subclass if one requires the avoidance of flexible navifgation.
      true
    end

    delegate :token, to: :transient_registration

    attr_accessor :transient_registration

    define_model_callbacks :initialize

    # If the record is new, and not yet persisted (which it is when the start
    # page is first submitted) then we have nothing to validate hence the check
    validates :token, "defra_ruby/validators/token": true, if: -> { transient_registration&.persisted? }

    def initialize(transient_registration)
      run_callbacks :initialize do
        # Get values from registration so form will be pre-filled
        @transient_registration = transient_registration
      end
    end

    def submit(attributes)
      attributes = strip_whitespace(attributes)
      transient_registration.attributes = attributes

      return transient_registration.save! if valid?

      false
    end
  end
end
