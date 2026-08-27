# frozen_string_literal: true

module WasteExemptionsEngine
  class PersonFormsController < FormsController
    def create(form_class, form)
      if params[:commit] == I18n.t("waste_exemptions_engine.#{form}s.new.add_person_link")
        submit_and_add_another(form_class, form)
      else
        super
      end
    end

    def submit_and_add_another(form_class, form)
      return unless set_up_form(form_class, form, params[:token])

      form_instance_variable = instance_variable_get("@#{form}")

      respond_to do |format|
        if form_instance_variable.submit(params[form])
          format.html { redirect_to_correct_form }
        else
          format.html { render :new }
        end
      end
    end

    def delete_person(form_class, form)
      return unless set_up_form(form_class, form, params[:token])

      respond_to do |format|
        person = @transient_registration.transient_people.find_by(id: params[:id])
        person&.delete

        format.html { redirect_to_correct_form }
      end
    end
  end
end
