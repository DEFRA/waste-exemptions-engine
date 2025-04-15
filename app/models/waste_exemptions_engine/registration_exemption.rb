# frozen_string_literal: true

module WasteExemptionsEngine
  class RegistrationExemption < ApplicationRecord
    self.table_name = "registration_exemptions"

    has_paper_trail if: proc(&:persist_version?)

    include CanBeOrderedByStateAndExemptionId

    belongs_to :registration
    belongs_to :exemption

    scope :active, -> { where(state: :active) }
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
  end
end
