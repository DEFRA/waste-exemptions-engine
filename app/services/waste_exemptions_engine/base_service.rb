# frozen_string_literal: true

module WasteExemptionsEngine
  class BaseService
    def self.run(attrs)
      new.run(attrs)
    end
  end
end
