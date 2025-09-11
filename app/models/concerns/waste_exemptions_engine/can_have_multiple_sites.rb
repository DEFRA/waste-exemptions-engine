# frozen_string_literal: true

module WasteExemptionsEngine
  module CanHaveMultipleSites
    extend ActiveSupport::Concern

    included do
      has_many :site_addresses, -> { site }, class_name: site_address_class_name, dependent: :destroy
    end
  end
end
