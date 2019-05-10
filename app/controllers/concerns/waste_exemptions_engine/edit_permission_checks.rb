# frozen_string_literal: true

# This concern is responsible for performing permissions checks. It's intended
# to be included overriden in host applications which have their own specific
# permissions and roles.
module WasteExemptionsEngine
  module EditPermissionChecks
    extend ActiveSupport::Concern

    included do
      prepend_before_action :check_edit_permissions

      def check_edit_permissions
        not_found unless edit_enabled? && current_user_can_edit?
      end

      def current_user_can_edit?
        true
      end

      def edit_enabled?
        WasteExemptionsEngine.configuration.edit_enabled
      end
    end
  end
end
