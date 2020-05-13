# frozen_string_literal: true

module WasteExemptionsEngine
  module CannotGoBackForm
    extend ActiveSupport::Concern

    included do
      # Override this method as user shouldn't be able to go back from this page
      def go_back; end
    end
  end
end
