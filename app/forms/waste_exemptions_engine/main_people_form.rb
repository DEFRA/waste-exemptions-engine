# frozen_string_literal: true

module WasteExemptionsEngine
  class MainPeopleForm < BaseForm
    delegate :transient_people, :business_type, to: :transient_registration

    attr_accessor :first_name, :last_name

    validates_with MainPersonFormValidator, attributes: %i[first_name last_name]

    def submit(params)
      # Assign the params for validation and pass them to the BaseForm method for updating
      self.first_name = params[:first_name]
      self.last_name = params[:last_name]

      set_up_new_person if valid? && self.first_name.present? && self.last_name.present?

      super({})
    end

    private

    def set_up_new_person
      transient_people.build(
        first_name: first_name,
        last_name: last_name
      )
    end
  end
end
