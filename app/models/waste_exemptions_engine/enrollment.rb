# frozen_string_literal: true

module WasteExemptionsEngine
  class Enrollment < ActiveRecord::Base
    include CanChangeWorkflowStatus

    # HasSecureToken provides an easy way to generate unique random tokens for
    # any model in ruby on rails. We use it to uniquely identify an enrollment
    # by something other than it's db ID, or its reference number. We can then
    # use token instead of ID to identify an enrollment during the journey. The
    # format makes it sufficiently hard for another user to attempt to 'guess'
    # the token of another enrollment in order to see its details.
    # See https://github.com/robertomiranda/has_secure_token
    has_secure_token
    validates_presence_of :token, on: :save

    self.table_name = "enrollments"
  end
end
