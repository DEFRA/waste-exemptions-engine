# frozen_string_literal: true

module Helpers
  module ModelProperties
    ADDRESS = %i[
      address_type
      mode
      uprn
      organisation
      premises
      street_address
      locality
      city
      postcode
      x
      y
      coordinate_system
      blpu_state_code
      postal_address_code
      logical_status_code
      source_data_type
      country_iso
      grid_reference
      description
    ].freeze

    EXEMPTION = %i[
      category
      code
      url
      summary
      description
      guidance
    ].freeze

    PERSON = %i[
      first_name
      last_name
      person_type
    ].freeze

    REGISTRATION_EXEMPTION = %i[
      state
      deregistration_message
      deregistered_on
      registered_on
      expires_on
    ].freeze

    TRANSIENT_REGISTRATION_EXEMPTION = (REGISTRATION_EXEMPTION - %i[deregistration_message deregistered_on]).freeze

    REGISTRATION = %i[
      reference
      location
      applicant_first_name
      applicant_last_name
      applicant_phone
      applicant_email
      business_type
      operator_name
      company_no
      contact_first_name
      contact_last_name
      contact_position
      contact_phone
      contact_email
      on_a_farm
      is_a_farmer
      submitted_at
      assistance_mode
    ].freeze

    TRANSIENT_REGISTRATION = (REGISTRATION + %i[
      token
      workflow_state
      start_option
      declaration
      temp_operator_postcode
      temp_contact_postcode
      temp_site_postcode
      temp_grid_reference
      temp_site_description
      address_finder_error
      type
    ]).freeze

    EDITED_REGISTRATION_UNCOPYABLE = (TRANSIENT_REGISTRATION - %i[
      address_finder_error
      type
      workflow_state
    ]).freeze
  end
end
