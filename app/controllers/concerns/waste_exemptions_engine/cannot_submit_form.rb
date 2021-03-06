# frozen_string_literal: true

module WasteExemptionsEngine
  module CannotSubmitForm
    extend ActiveSupport::Concern

    included do
      # Override this method as user shouldn't be able to "submit" this page
      def create
        raise ActionController::RoutingError, "Unsubmittable"
      end
    end
  end
end
