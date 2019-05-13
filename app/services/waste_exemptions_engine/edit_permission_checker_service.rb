# frozen_string_literal: true

# This concern is responsible for performing permissions checks. It's intended
# to be included overriden in host applications which have their own specific
# permissions and roles.
module WasteExemptionsEngine
  class EditPermissionCheckerService < BaseService
    def run(*)
      true
    end
  end
end
