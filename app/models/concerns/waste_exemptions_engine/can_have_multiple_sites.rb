# frozen_string_literal: true

module WasteExemptionsEngine
  module CanHaveMultipleSites
    extend ActiveSupport::Concern

    included do
      has_many :site_addresses, class_name: "WasteExemptionsEngine::SiteAddress", foreign_key: :registration_id,
                                dependent: :destroy
    end

    def multisite?
      site_addresses.count > 1
    end
  end
end
