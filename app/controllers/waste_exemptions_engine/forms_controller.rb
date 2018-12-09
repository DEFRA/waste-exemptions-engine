# frozen_string_literal: true

module WasteExemptionsEngine
  class FormsController < ApplicationController
    include ActionView::Helpers::UrlHelper

    before_action :back_button_cache_buster

    # Expects a form class name (eg BusinessTypeForm) and a snake_case name for the form (eg business_type_form)
    def new(form_class, form)
      set_up_form(form_class, form, params[:id], true)
    end

    # Expects a form class name (eg BusinessTypeForm) and a snake_case name for the form (eg business_type_form)
    def create(form_class, form)
      return false unless set_up_form(form_class, form, params[form][:id])

      # Submit the form by getting the instance variable we just set
      submit_form(instance_variable_get("@#{form}"), params[form])
    end

    def go_back
      set_transient_registration(params[:id])

      @enrollment.back! if form_matches_state?
      redirect_to_correct_form
    end

    private

    def set_enrollment(id)
      @enrollment = Enrollment.where(
        id: id
      ).first || Enrollment.new
    end

    # Expects a form class name (eg BusinessTypeForm), a snake_case name for the form (eg business_type_form),
    # and the id param
    def set_up_form(form_class, form, id, get_request = false)
      set_enrollment(id)
      set_workflow_state if get_request

      return false unless setup_checks_pass?

      # Set an instance variable for the form (eg. @business_type_form) using the provided class (eg. BusinessTypeForm)
      instance_variable_set("@#{form}", form_class.new(@enrollment))
    end

    def submit_form(form, params)
      respond_to do |format|
        if form.submit(params)
          @enrollment.next!
          format.html { redirect_to_correct_form }
          true
        else
          format.html { render :new }
          false
        end
      end
    end

    def redirect_to_correct_form
      redirect_to form_path
    end

    # Get the path based on the workflow state, with id as params, ie:
    # new_state_name_path/:id
    def form_path
      send("new_#{@enrollment.workflow_state}_path".to_sym, @enrollment.id)
    end

    def setup_checks_pass?
      enrollment_is_valid? && state_is_correct?
    end

    def set_workflow_state
      return unless state_can_navigate_flexibly?(@enrollment.workflow_state)
      return unless state_can_navigate_flexibly?(requested_state)

      @enrollment.update_attributes(workflow_state: requested_state)
    end

    def state_can_navigate_flexibly?(state)
      form_class = WasteExemptionsEngine.const_get(state.camelize)
      form_class.included_modules.include?(CanNavigateFlexibly)
    end

    def requested_state
      # Get the controller_name, excluding the last character (for example, changing location_forms to location_form)
      controller_name[0..-2]
    end

    # Guards

    def enrollment_is_valid?
      return true if @enrollment.valid?

      redirect_to page_path("invalid")
      false
    end

    def state_is_correct?
      return true if form_matches_state?

      redirect_to_correct_form
      false
    end

    def form_matches_state?
      controller_name == "#{@enrollment.workflow_state}s"
    end

    # http://jacopretorius.net/2014/01/force-page-to-reload-on-browser-back-in-rails.html
    def back_button_cache_buster
      response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
      response.headers["Pragma"] = "no-cache"
      response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
    end
  end
end
