# frozen_string_literal: true

module WasteExemptionsEngine
  class FormsController < ::WasteExemptionsEngine::ApplicationController
    include ActionView::Helpers::UrlHelper
    include CanRedirectFormToCorrectPath

    before_action :back_button_cache_buster

    # Expects a form class name (eg BusinessTypeForm) and a snake_case name for the form (eg business_type_form)
    def new(form_class, form)
      set_up_form(form_class, form, params[:token], get_request: true)
    end

    # Expects a form class name (eg BusinessTypeForm) and a snake_case name for the form (eg business_type_form)
    def create(form_class, form)
      return false unless set_up_form(form_class, form, params[:token])

      # Submit the form by getting the instance variable we just set
      submit_form(instance_variable_get("@#{form}"), transient_registration_attributes)
    end

    def go_back
      find_or_initialize_registration(params[:token])

      @transient_registration.previous_valid_state!
      redirect_to_correct_form
    end

    private

    def transient_registration_attributes
      # Subclassess to define correct permitted attributes when relevant
      params.permit
    end

    def find_or_initialize_registration(token)
      @transient_registration = TransientRegistration.find_by(
        token: token
      ) || NewRegistration.new
    end

    # Expects a form class name (eg BusinessTypeForm), a snake_case name for the form (eg business_type_form),
    # and the token param
    def set_up_form(form_class, form, token, get_request: false)
      find_or_initialize_registration(token)
      set_workflow_state if get_request
      return false unless setup_checks_pass?

      # Set an instance variable for the form (eg. @business_type_form) using the provided class (eg. BusinessTypeForm)
      instance_variable_set("@#{form}", form_class.new(@transient_registration))
    end

    def submit_form(form, params, redirect_to_next: true)
      respond_to do |format|
        if form.submit(params)
          @transient_registration.next_state! if redirect_to_next
          format.html { redirect_to_correct_form }
          true
        else
          format.html { render :new }
          false
        end
      end
    end

    def setup_checks_pass?
      registration_is_valid? && state_is_correct?
    end

    def set_workflow_state
      return unless state_can_navigate_flexibly?(@transient_registration.workflow_state)
      return unless state_can_navigate_flexibly?(requested_state)
      return unless @transient_registration.persisted?

      update_workflow_state(requested_state)
    end

    def update_workflow_state(workflow_state)
      @transient_registration.update(workflow_state: workflow_state)
    end

    def state_can_navigate_flexibly?(state)
      form_class = WasteExemptionsEngine.const_get(state.camelize)
      form_class.can_navigate_flexibly?
    end

    def requested_state
      # Get the controller_name, excluding the last character (for example, changing location_forms to location_form)
      controller_name[0..-2]
    end

    # Guards

    def registration_is_valid?
      return true if @transient_registration.valid?

      redirect_to page_path("invalid")
      false
    end

    def state_is_correct?
      return true if form_matches_state?

      redirect_to_correct_form(WasteExemptionsEngine::ApplicationController::UNSUCCESSFUL_REDIRECTION_CODE)
      false
    end

    def form_matches_state?
      controller_name == "#{@transient_registration.workflow_state}s"
    end

    # http://jacopretorius.net/2014/01/force-page-to-reload-on-browser-back-in-rails.html
    def back_button_cache_buster
      response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
      response.headers["Pragma"] = "no-cache"
      response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
    end

    def not_found
      raise ActionController::RoutingError, "Not Found"
    end
  end
end
