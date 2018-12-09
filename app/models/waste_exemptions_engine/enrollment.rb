# frozen_string_literal: true

module WasteExemptionsEngine
  class Enrollment < ActiveRecord::Base
    include CanChangeWorkflowStatus

    self.table_name = "enrollments"
  end
end
