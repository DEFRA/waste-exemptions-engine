# frozen_string_literal: true

module WasteExemptionsEngine
  class ConfirmEmailForm
    include ActiveModel::Model

    attr_accessor :email
  end
end
