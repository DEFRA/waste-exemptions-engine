# frozen_string_literal: true

module WasteExemptionsEngine
  class RegistrationExemption < ApplicationRecord
    self.table_name = "registration_exemptions"

    has_paper_trail if: proc(&:persist_version?)

    include CanBeOrderedByStateAndExemptionId

    belongs_to :registration
    belongs_to :exemption
    belongs_to :address, optional: true

    scope :active, -> { where(state: :active) }
    scope :for_site_address, ->(address) { where(address: address) }
    scope :expired, -> { where(state: :expired) }
    scope :ceased, -> { where(state: :ceased) }
    scope :order_by_exemption, -> { order(exemption_id: :asc) }
    scope :deregistered, -> { where(state: %i[ceased revoked]) }

    def persist_version?
      # When the RE is ceased/revoked multiple saves happen, the first of which
      # is updating the deregistered_at timestamp. Since we only persist a
      # version on these 2 events and don't want to include this timestamp in
      # the version being persisted, we trigger the paper_trail hooks when this
      # timestamp is first updated.
      saved_change_to_deregistered_at?
    end

    def deregistered_by
      # Return the column value if present (new records)
      # Fall back to version lookup for historical records
      return self[:deregistered_by] if self[:deregistered_by].present?

      deregistration_version = versions.where(event: "update").last
      return if deregistration_version.blank?

      deregistration_version.whodunnit
    end
  end
end
