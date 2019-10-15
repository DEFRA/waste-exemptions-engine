# frozen_string_literal: true

module WasteExemptionsEngine
  class MainPeopleFormsController < PersonFormsController
    def new
      super(MainPeopleForm, "main_people_form")
    end

    def create
      super(MainPeopleForm, "main_people_form")
    end

    def delete_person
      super(MainPeopleForm, "main_people_form")
    end

    private

    def transient_registration_attributes
      params.require(:main_people_form).permit(:first_name, :last_name)
    end
  end
end
