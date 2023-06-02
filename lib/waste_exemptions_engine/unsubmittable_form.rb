# frozen_string_literal: true

module WasteExemptionsEngine
  class UnsubmittableForm < StandardError
    def initialize(msg = "This form does not support POST requests.")
      super
    end
  end
end
