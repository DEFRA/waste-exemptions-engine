# frozen_string_literal: true

module WasteExemptionsEngine
  class PostcodeForm < BaseForm
    private

    def format_postcode(postcode)
      return unless postcode.present?

      postcode.upcase!
      postcode.strip!
    end
  end
end
