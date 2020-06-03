# frozen_string_literal: true

module WasteExemptionsEngine
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true
  end
end
