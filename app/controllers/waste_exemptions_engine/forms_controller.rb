# frozen_string_literal: true

module WasteExemptionsEngine
  class FormsController < ApplicationController
    include ActionView::Helpers::UrlHelper

    before_action :back_button_cache_buster

    # Expects a form class name (eg BusinessTypeForm) and a snake_case name for the form (eg business_type_form)
    def new(form_class, form)
      set_up_form(form_class, form, params[:token], true)
    end

    # Expects a form class name (eg BusinessTypeForm) and a snake_case name for the form (eg business_type_form)
    def create(form_class, form)
      return false unless set_up_form(form_class, form, params[form][:token])

      # Submit the form by getting the instance variable we just set
      submit_form(instance_variable_get("@#{form}"), params[form])
    end

    def go_back
      find_or_initialize_registration(params[:token])

      @transient_registration.back! if form_matches_state?
      redirect_to_correct_form
    end

    private

    def find_or_initialize_registration(token)
      @transient_registration = TransientRegistration.where(
        token: token
      ).first || NewRegistration.new
    end

    # Expects a form class name (eg BusinessTypeForm), a snake_case name for the form (eg business_type_form),
    # and the token param
    def set_up_form(form_class, form, token, get_request = false)
      find_or_initialize_registration(token)
      set_workflow_state if get_request

      return false unless setup_checks_pass?

      # Set an instance variable for the form (eg. @business_type_form) using the provided class (eg. BusinessTypeForm)
      instance_variable_set("@#{form}", form_class.new(@transient_registration))
    end

    def submit_form(form, params)
      respond_to do |format|
        if form.submit(params)
          @transient_registration.next!
          format.html { redirect_to_correct_form }
          true
        else
          format.html { render :new }
          false
        end
      end
    end

    def redirect_to_correct_form(
      status_code = WasteExemptionsEngine::ApplicationController::SUCCESSFUL_REDIRECTION_CODE
    )
      redirect_to form_path, status: status_code
    end

    # Get the path based on the workflow state
    def form_path
      @transient_registration.save unless @transient_registration.token.present?
      send("new_#{@transient_registration.workflow_state}_path".to_sym, @transient_registration.token)
    end

    def setup_checks_pass?
      registration_is_valid? && state_is_correct? && edit_checks_pass?
    end

    def set_workflow_state
      return unless state_can_navigate_flexibly?(@transient_registration.workflow_state)
      return unless state_can_navigate_flexibly?(requested_state)

      @transient_registration.update_attributes(workflow_state: requested_state)
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

    def edit_checks_pass?
      return true unless @transient_registration.is_a?(EditRegistration)
      return true if edit_enabled? && current_user_can_edit?

      redirect_to error_path(status: 404), status: 404
      false
    end

    def edit_enabled?
      WasteExemptionsEngine.configuration.edit_enabled
    end

    # http://jacopretorius.net/2014/01/force-page-to-reload-on-browser-back-in-rails.html
    def back_button_cache_buster
      response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
      response.headers["Pragma"] = "no-cache"
      response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
    end
  end
end
