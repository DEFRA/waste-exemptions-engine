# frozen_string_literal: true

module WasteExemptionsEngine
  class CommunicationLog < ApplicationRecord

    self.table_name = "communication_logs"

    MESSAGE_TYPES = %w[letter email text].freeze
    STATUSES = %w[sent sending delivered permanent-failure temporary-failure technical-failure returned].freeze

    validates :message_type, presence: true, inclusion: { in: MESSAGE_TYPES }
    validates :status, inclusion: { in: STATUSES }, allow_nil: true

    belongs_to :registration
  end
end
