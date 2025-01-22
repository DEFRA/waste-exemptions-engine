# frozen_string_literal: true

module WasteExemptionsEngine
  class BetaParticipant < ApplicationRecord
    self.table_name = "beta_participants"
    belongs_to :registration, polymorphic: true

    validates :reg_number, presence: true, uniqueness: true
    validates :token, uniqueness: true

    before_create :generate_token

    def generate_token
      self.token = SecureRandom.uuid if token.blank?
    end
  end
end
