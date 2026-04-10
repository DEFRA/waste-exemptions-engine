# frozen_string_literal: true

module WasteExemptionsEngine
  module CanRedirectSitesFormToLastPage
    extend ActiveSupport::Concern

    private

    def form_path
      return new_sites_form_path(token: @transient_registration.token, page: "last") if @transient_registration.workflow_state == "sites_form"

      super
    end
  end
end
