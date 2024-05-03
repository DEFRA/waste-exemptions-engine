# frozen_string_literal: true

# This module is used to edit price fields stored in pence as pounds in the UI. It works by adding
# a temporary field to the model for each field that needs to be converted, and then converting the
# value to pence when the form is submitted. The module also includes a validation method to ensure
# that the user has entered a valid price.
#
# Usage:
#   include CanConvertPenceToPounds
#   pence_to_pounds_fields only: %i[registration_charge compliance_charge]
#
module WasteExemptionsEngine
  module CanConvertPenceToPounds
    extend ActiveSupport::Concern

    # rubocop:disable Metrics/BlockLength: # Splitting this method up would force block limits to be exceeded
    class_methods do
      private

      def pence_to_pounds_fields(opts = {})
        pence_to_pounds_fields = opts[:only]

        pence_to_pounds_fields.each do |field|
          define_instance_methods_for_pence_to_pounds_fields(field)
        end
      end

      def define_instance_methods_for_pence_to_pounds_fields(field)
        attr_accessor "#{field}_temp"
        attr_accessor :"#{field}_in_pounds"

        define_method("#{field}_in_pounds") do
          if errors["#{field}_in_pounds"].any?
            send("#{field}_temp")
          elsif send(field)
            format("%.2f", send(field).to_f / 100)
          end
        end

        define_method("#{field}_in_pounds=") do |value|
          send("#{field}_temp=", value)
          value = value.gsub(/[^0-9.]/, "")
          send("#{field}=", (value.to_f * 100).to_i)
        end

        define_method("validate_#{field}_in_pounds") do
          return if send("#{field}_temp").blank?
          return if send("#{field}_temp").match?(/^\d+(\.\d{0,2})?$/)

          errors.add("#{field}_in_pounds", "is not a valid price")
        end

        validate :"validate_#{field}_in_pounds"
      end
    end
    # rubocop:enable Metrics/BlockLength
  end
end
