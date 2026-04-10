# frozen_string_literal: true

module WasteExemptionsEngine
  module CanRedirectSitesFormToLastPage
    extend ActiveSupport::Concern

    private

    def form_path
      if @transient_registration.workflow_state == "sites_form"
        return new_sites_form_path(token: @transient_registration.token,
                                   page: "last")
      end

      super
    end
  end
end
