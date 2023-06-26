# frozen_string_literal: true

module WasteExemptionsEngine
  class CommunicationLog < ApplicationRecord

    self.table_name = "communication_logs"

    MESSAGE_TYPES = %w[letter email text].freeze

    validates :message_type, presence: true, inclusion: { in: MESSAGE_TYPES }

    belongs_to :registration
  end
end
