# frozen_string_literal: true

module WasteExemptionsEngine
  class PersonForm < BaseForm

    attr_accessor :first_name, :last_name

    def initialize(transient_registration)
      super
    end

    def submit(params)
      # Assign the params for validation and pass them to the BaseForm method for updating
      self.first_name = params[:first_name]
      self.last_name = params[:last_name]

      set_up_new_person if fields_have_content?

      super({}, params[:token])
    end

    # Used to switch on usage of the :position attribute for validation and form-filling
    def position?
      false
    end

    def fields_have_content?
      fields = [first_name, last_name]
      fields.each do |field|
        return true if field.present? && field.to_s.length.positive?
      end

      false
    end

    # Methods which are called in this class but defined in subclasses
    # We should throw descriptive errors in case an additional subclass of PersonForm is ever added

    def person_type
      implemented_in_subclass
    end

    private

    def set_up_new_person
      @transient_registration.transient_people.build(
        first_name: first_name,
        last_name: last_name,
        person_type: person_type
      )
    end
  end
end
