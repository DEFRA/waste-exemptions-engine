# frozen_string_literal: true

module WasteExemptionsEngine
  module EditPermissionChecks
    extend ActiveSupport::Concern

    included do
      prepend_before_action :check_edit_permissions

      def check_edit_permissions
        not_found unless edit_enabled? && current_user_can_edit?
      end

      def current_user_can_edit?
        user = nil

        # rubocop:disable Lint/SuppressedException
        begin
          user = current_user
        rescue NotImplementedError
          # do nothing
        end
        # rubocop:enable Lint/SuppressedException

        EditPermissionCheckerService.run(current_user: user)
      end

      def edit_enabled?
        WasteExemptionsEngine.configuration.edit_enabled
      end
    end
  end
end
