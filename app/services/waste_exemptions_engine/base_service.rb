# frozen_string_literal: true

module WasteExemptionsEngine
  class BaseService
    def self.run(options = nil)
      if options.is_a?(String)
        new.run(options)
      elsif options
        new.run(**options)
      else
        new.run
      end
    end
  end
end
