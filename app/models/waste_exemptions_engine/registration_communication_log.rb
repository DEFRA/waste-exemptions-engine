# frozen_string_literal: true

module WasteExemptionsEngine
  class RegistrationCommunicationLog < ApplicationRecord
    self.table_name = "registration_communication_logs"

    belongs_to :registration
    belongs_to :communication_log
  end
end
