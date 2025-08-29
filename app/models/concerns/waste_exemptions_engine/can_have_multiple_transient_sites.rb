# frozen_string_literal: true

module WasteExemptionsEngine
  module CanHaveMultipleTransientSites
    extend ActiveSupport::Concern

    included do
      has_many :site_addresses, -> { site }, class_name: "TransientAddress", dependent: :destroy
    end

    def multisite?
      site_addresses.count > 1
    end
  end
end
