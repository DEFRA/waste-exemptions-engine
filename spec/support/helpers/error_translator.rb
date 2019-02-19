# frozen_string_literal: true

module Helpers
  module Translator
    def self.error_message(record, attribute, error)
      class_name = record.class.to_s.underscore
      I18n.t("activemodel.errors.models.#{class_name}.attributes.#{attribute}.#{error}")
    end

    def self.state_error_message(record, error, state, options = {})
      class_name = record.class.to_s.underscore
      I18n.t("activemodel.errors.models.#{class_name}.#{error}.#{state}", options)
    end

    def self.main_person_error_message(validatable, num_people, min_people)
      state_key = num_people > min_people ? :too_many_main_people : :not_enough_main_people
      if min_people == 1
        state_error_message(validatable, state_key, :one)
      else
        state_error_message(validatable, state_key, :other, count: 2)
      end
    end
  end
end
