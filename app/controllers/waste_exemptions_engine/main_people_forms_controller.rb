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
  end
end
