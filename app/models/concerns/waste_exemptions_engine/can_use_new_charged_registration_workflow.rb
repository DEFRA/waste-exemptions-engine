# frozen_string_literal: true

module WasteExemptionsEngine
  module CanUseNewChargedRegistrationWorkflow
    extend ActiveSupport::Concern

    included do
      include AASM

      aasm column: :workflow_state do
        # States / forms

        # Start
        state :beta_start_form, initial: true

        # Location
        state :location_form
        state :register_in_northern_ireland_form
        state :register_in_scotland_form
        state :register_in_wales_form

        # Applicant details
        state :applicant_name_form
        state :applicant_phone_form
        state :applicant_email_form

        # Operator details
        state :business_type_form
        state :main_people_form
        state :registration_number_form
        state :check_registered_name_and_address_form
        state :incorrect_company_form
        state :operator_name_form
        state :operator_postcode_form
        state :operator_address_lookup_form
        state :operator_address_manual_form

        # Contact details
        state :check_contact_name_form
        state :contact_name_form
        state :contact_position_form
        state :check_contact_phone_form
        state :contact_phone_form
        state :check_contact_email_form
        state :contact_email_form
        state :check_contact_address_form
        state :contact_postcode_form
        state :contact_address_lookup_form
        state :contact_address_manual_form

        # Farm questions
        state :on_a_farm_form
        state :is_a_farmer_form

        # Site questions
        state :site_grid_reference_form
        state :check_site_address_form
        state :site_postcode_form
        state :site_address_lookup_form

        state :waste_activities_form
        state :activity_exemptions_form
        state :farm_exemptions_form
        state :confirm_activity_exemptions_form
        state :confirm_farm_exemptions_form
        state :exemptions_summary_form
        state :no_farm_exemptions_selected_form

        # End pages
        state :check_your_answers_form
        state :declaration_form
        state :payment_summary_form
        state :govpay_form
        state :registration_complete_form
        state :private_beta_registration_complete_form
        state :registration_received_pending_payment_form

        # Transitions
        event :next do
          # Start -> Location
          transitions from: :beta_start_form,
                      to: :location_form

          # Location -> Register in Northern Ireland
          transitions from: :location_form,
                      to: :register_in_northern_ireland_form,
                      if: :should_register_in_northern_ireland?

          # Location -> Register in Scotland
          transitions from: :location_form,
                      to: :register_in_scotland_form,
                      if: :should_register_in_scotland?

          # Location -> Register in Wales
          transitions from: :location_form,
                      to: :register_in_wales_form,
                      if: :should_register_in_wales?

          # Location -> On a farm
          transitions from: :location_form,
                      to: :on_a_farm_form

          # On a farm -> Is a farmer
          transitions from: :on_a_farm_form,
                      to: :is_a_farmer_form,
                      unless: :check_your_answers_flow?

          # Is a farmer -> Business type
          transitions from: :is_a_farmer_form,
                      to: :business_type_form,
                      unless: :check_your_answers_flow?

          ### PARTNER FLOW

          # Business type -> Main people (partnership)
          transitions from: :business_type_form,
                      to: :main_people_form,
                      if: :partnership?

          # Main people -> Operator name
          transitions from: :main_people_form,
                      to: :operator_name_form,
                      unless: :check_your_answers_flow?

          ### NON COMPANY FLOW (Individual, local authority and charity)

          # Business type -> Operator name
          transitions from: :business_type_form,
                      to: :operator_name_form,
                      if: :skip_registration_number?

          ### PARTNER && NON COMPANY FLOW

          # Operator name -> Waste activities
          transitions from: :operator_name_form,
                      to: :farm_exemptions_form,
                      if: :farm_affiliated?

          transitions from: :operator_name_form,
                      to: :waste_activities_form,
                      unless: :check_your_answers_flow?

          ### COMPANY FLOW (limited and llp))

          # Business type -> Registration number
          transitions from: :business_type_form,
                      to: :registration_number_form

          # Registration number -> Check registered name and address
          transitions from: :registration_number_form,
                      to: :check_registered_name_and_address_form

          # Check registered name and address -> Incorrect company
          transitions from: :check_registered_name_and_address_form,
                      to: :incorrect_company_form,
                      if: :companies_house_details_incorrect?

          # Check registered name and address -> Waste activities
          transitions from: :check_registered_name_and_address_form,
                      to: :farm_exemptions_form,
                      if: :farm_affiliated?

          transitions from: :check_registered_name_and_address_form,
                      to: :waste_activities_form,
                      unless: :check_your_answers_flow?

          # Incorrect company -> Registration number
          transitions from: :incorrect_company_form,
                      to: :registration_number_form

          ### WASTE ACTIVITIES & EXEMPTIONS

          # Waste Activities -> Activity Exemptions
          transitions from: :waste_activities_form,
                      to: :activity_exemptions_form

          # Activity Exemptions -> Confirm Exemptions
          transitions from: :activity_exemptions_form,
                      to: :confirm_activity_exemptions_form

          transitions from: :farm_exemptions_form,
                      to: :confirm_farm_exemptions_form

          # Confirm Exemptions -> Site Grid Reference
          transitions from: :confirm_activity_exemptions_form,
                      to: :site_grid_reference_form,
                      if: :proceed_with_selected_exemptions?,
                      unless: :check_your_answers_flow?

          transitions from: :confirm_farm_exemptions_form,
                      to: :no_farm_exemptions_selected_form,
                      if: :no_exemptions_selected?,
                      unless: :check_your_answers_flow?

          transitions from: :confirm_farm_exemptions_form,
                      to: :site_grid_reference_form,
                      if: :proceed_with_selected_farm_exemptions?,
                      unless: :check_your_answers_flow?

          # Confirm Exemptions -> Waste Activities
          transitions from: :confirm_activity_exemptions_form,
                      to: :waste_activities_form,
                      if: :reselect_exemptions?

          transitions from: :confirm_farm_exemptions_form,
                      to: :waste_activities_form,
                      if: :add_additional_non_farm_exemptions?

          ### SITE LOCATION

          # Site Grid Reference -> Site Postcode
          transitions from: :site_grid_reference_form,
                      to: :site_postcode_form,
                      if: :skip_to_manual_address?,
                      unless: :check_your_answers_flow?

          # Site Postcode -> Site Address Lookup
          transitions from: :site_postcode_form,
                      to: :site_address_lookup_form

          # Site Address Lookup -> Operator Postcode
          transitions from: :site_address_lookup_form,
                      to: :operator_postcode_form,
                      unless: :check_your_answers_flow?

          # Check Site Address -> Operator Postcode
          transitions from: :check_site_address_form,
                      to: :operator_postcode_form

          # Site Grid Reference -> Operator Postcode
          transitions from: :site_grid_reference_form,
                      to: :operator_postcode_form,
                      unless: :check_your_answers_flow?

          ### OPERATOR LOCATION

          # Operator Postcode -> Operator Address Manual
          transitions from: :operator_postcode_form,
                      to: :operator_address_manual_form,
                      if: :skip_to_manual_address?

          # Operator Postcode -> Operator Address Lookup
          transitions from: :operator_postcode_form,
                      to: :operator_address_lookup_form

          # Operator Address Lookup -> Operator Address Manual
          transitions from: :operator_address_lookup_form,
                      to: :operator_address_manual_form,
                      if: :skip_to_manual_address?

          # Operator Address Lookup -> Applicant Name
          transitions from: :operator_address_lookup_form,
                      to: :applicant_name_form,
                      unless: :check_your_answers_flow?

          # Operator Address Manual -> Applicant Name
          transitions from: :operator_address_manual_form,
                      to: :applicant_name_form,
                      unless: :check_your_answers_flow?

          ### APPLICANT DETAILS

          # Applicant Name -> Applicant Phone
          transitions from: :applicant_name_form,
                      to: :applicant_phone_form,
                      unless: :check_your_answers_flow?

          # Applicant Phone -> Applicant Email
          transitions from: :applicant_phone_form,
                      to: :applicant_email_form,
                      unless: :check_your_answers_flow?

          # Applicant Email -> Check Contact Name
          transitions from: :applicant_email_form,
                      to: :check_contact_name_form,
                      unless: :check_your_answers_flow?

          ### CONTACT DETAILS

          # Check Contact Name -> Contact Name
          transitions from: :check_contact_name_form,
                      to: :contact_name_form,
                      unless: :temp_reuse_applicant_name?

          # Check Contact Name -> Contact Position
          transitions from: :check_contact_name_form,
                      to: :contact_position_form

          # Contact Name -> Contact Position
          transitions from: :contact_name_form,
                      to: :contact_position_form,
                      unless: :check_your_answers_flow?

          # Contact Position -> Check Contact Phone
          transitions from: :contact_position_form,
                      to: :check_contact_phone_form,
                      unless: :check_your_answers_flow?

          # Check Contact Phone -> Contact Phone
          transitions from: :check_contact_phone_form,
                      to: :contact_phone_form,
                      unless: :temp_reuse_applicant_phone?

          # Check Contact Phone -> Contact Email
          transitions from: :check_contact_phone_form,
                      to: :contact_email_form,
                      unless: :applicant_email?

          # Contact Phone -> Contact Email
          transitions from: :check_contact_phone_form,
                      to: :check_contact_email_form

          # Contact Phone -> Contact Email
          transitions from: :contact_phone_form,
                      to: :contact_email_form,
                      unless: %i[applicant_email check_your_answers_flow?]

          # Contact Phone -> Check Contact Email
          transitions from: :contact_phone_form,
                      to: :check_contact_email_form,
                      unless: :check_your_answers_flow?

          # Check Contact Email -> Contact Email
          transitions from: :check_contact_email_form,
                      to: :contact_email_form,
                      unless: :temp_reuse_applicant_email?

          # Check Contact Email -> Check Contact Address
          transitions from: :check_contact_email_form,
                      to: :check_contact_address_form,
                      if: :temp_reuse_applicant_email?

          # Contact Email -> Check Contact Address
          transitions from: :contact_email_form,
                      to: :check_contact_address_form,
                      unless: :check_your_answers_flow?

          # Check Contact Address -> Contact Postcode
          transitions from: :check_contact_address_form,
                      to: :contact_postcode_form,
                      unless: :temp_reuse_operator_address?

          # Check Contact Address -> Check Your Answers
          transitions from: :check_contact_address_form,
                      to: :check_your_answers_form,
                      if: :temp_reuse_operator_address?

          # Contact Postcode -> Contact Address Manual
          transitions from: :contact_postcode_form,
                      to: :contact_address_manual_form,
                      if: :skip_to_manual_address?

          # Contact Postcode -> Contact Address Lookup
          transitions from: :contact_postcode_form,
                      to: :contact_address_lookup_form

          # Contact Address Lookup -> Contact Address Manual
          transitions from: :contact_address_lookup_form,
                      to: :contact_address_manual_form,
                      if: :skip_to_manual_address?

          # Contact Address Lookup -> Check Your Answers
          transitions from: :contact_address_lookup_form,
                      to: :check_your_answers_form,
                      unless: :check_your_answers_flow?

          # Contact Address Manual -> Check Your Answers
          transitions from: :contact_address_manual_form,
                      to: :check_your_answers_form,
                      unless: :check_your_answers_flow?

          ### CHECK YOUR ANSWERS

          transitions from: :check_your_answers_form,
                      to: :exemptions_summary_form

          ### EXEMPTIONS SUMMARY

          transitions from: :exemptions_summary_form,
                      to: :declaration_form,
                      unless: :check_your_answers_flow?

          ### DECLARATION

          transitions from: :declaration_form,
                      to: :payment_summary_form

          ### PAYMENT SUMMARY

          transitions from: :payment_summary_form,
                      to: :private_beta_registration_complete_form

          # To be reinstated after private beta
          # transitions from: :payment_summary_form,
          #             to: :govpay_form,
          #             if: :paying_by_card?

          # transitions from: :payment_summary_form,
          #             to: :registration_received_pending_payment_form,
          #             if: :payment_via_bank_transfer?

          transitions from: :govpay_form,
                      to: :registration_received_pending_payment_form,
                      if: :pending_online_payment?

          transitions from: :govpay_form, to: :registration_complete_form

          ### CHECK YOUR ANSWERS CHANGE MINI-FLOW

          transitions from: :applicant_name_form,
                      to: :check_your_answers_form

          transitions from: :applicant_phone_form,
                      to: :check_your_answers_form

          transitions from: :applicant_email_form,
                      to: :check_your_answers_form

          transitions from: :confirm_farm_exemptions_form,
                      to: :check_your_answers_form

          transitions from: :confirm_activity_exemptions_form,
                      to: :check_your_answers_form

          transitions from: :contact_name_form,
                      to: :check_your_answers_form

          transitions from: :contact_position_form,
                      to: :check_your_answers_form

          transitions from: :contact_phone_form,
                      to: :check_your_answers_form

          transitions from: :contact_email_form,
                      to: :check_your_answers_form

          transitions from: :operator_name_form,
                      to: :check_your_answers_form

          transitions from: :operator_address_lookup_form,
                      to: :check_your_answers_form

          transitions from: :operator_address_manual_form,
                      to: :check_your_answers_form

          transitions from: :contact_address_lookup_form,
                      to: :check_your_answers_form

          transitions from: :contact_address_manual_form,
                      to: :check_your_answers_form

          transitions from: :on_a_farm_form,
                      to: :check_your_answers_form

          transitions from: :is_a_farmer_form,
                      to: :check_your_answers_form

          transitions from: :exemptions_summary_form,
                      to: :check_your_answers_form

          transitions from: :main_people_form,
                      to: :check_your_answers_form

          transitions from: :check_registered_name_and_address_form,
                      to: :check_your_answers_form

          transitions from: :site_grid_reference_form,
                      to: :check_your_answers_form

          transitions from: :site_address_lookup_form,
                      to: :check_your_answers_form
        end

        event :skip_to_manual_address do
          transitions from: :operator_postcode_form,
                      to: :operator_address_manual_form

          transitions from: :operator_address_lookup_form,
                      to: :operator_address_manual_form

          transitions from: :contact_postcode_form,
                      to: :contact_address_manual_form

          transitions from: :contact_address_lookup_form,
                      to: :contact_address_manual_form
        end

        event :skip_to_address do
          transitions from: :site_grid_reference_form,
                      to: :site_postcode_form
        end

        event :edit_exemptions do
          transitions from: :check_your_answers_form,
                      to: :farm_exemptions_form,
                      if: :check_your_answers_flow? && :farm_affiliated?

          transitions from: :check_your_answers_form,
                      to: :waste_activities_form,
                      if: :check_your_answers_flow?
        end

        event :edit_applicant_name do
          transitions from: :check_your_answers_form,
                      to: :applicant_name_form,
                      if: :check_your_answers_flow?
        end

        event :edit_applicant_phone do
          transitions from: :check_your_answers_form,
                      to: :applicant_phone_form,
                      if: :check_your_answers_flow?
        end

        event :edit_applicant_email do
          transitions from: :check_your_answers_form,
                      to: :applicant_email_form,
                      if: :check_your_answers_flow?
        end

        event :edit_contact_name do
          transitions from: :check_your_answers_form,
                      to: :contact_name_form,
                      if: :check_your_answers_flow?
        end

        event :edit_contact_position do
          transitions from: :check_your_answers_form,
                      to: :contact_position_form,
                      if: :check_your_answers_flow?
        end

        event :edit_contact_phone do
          transitions from: :check_your_answers_form,
                      to: :contact_phone_form,
                      if: :check_your_answers_flow?
        end

        event :edit_contact_email do
          transitions from: :check_your_answers_form,
                      to: :contact_email_form,
                      if: :check_your_answers_flow?
        end

        event :edit_operator_name do
          transitions from: :check_your_answers_form,
                      to: :operator_name_form,
                      if: :check_your_answers_flow?
        end

        event :edit_operator_address do
          transitions from: :check_your_answers_form,
                      to: :operator_postcode_form,
                      if: :check_your_answers_flow?
        end

        event :edit_main_people do
          transitions from: :check_your_answers_form,
                      to: :main_people_form,
                      if: :check_your_answers_flow?
        end

        event :edit_registration_number do
          transitions from: :check_your_answers_form,
                      to: :registration_number_form,
                      if: :check_your_answers_flow?
        end

        event :edit_site_address do
          transitions from: :check_your_answers_form,
                      to: :site_postcode_form,
                      if: :check_your_answers_flow?
        end

        event :edit_site_grid_reference do
          transitions from: :check_your_answers_form,
                      to: :site_grid_reference_form,
                      if: :check_your_answers_flow?
        end

        event :edit_contact_address do
          transitions from: :check_your_answers_form,
                      to: :contact_postcode_form,
                      if: :check_your_answers_flow?
        end

        event :edit_on_a_farm do
          transitions from: :check_your_answers_form,
                      to: :on_a_farm_form,
                      if: :check_your_answers_flow?
        end

        event :edit_is_a_farmer do
          transitions from: :check_your_answers_form,
                      to: :is_a_farmer_form,
                      if: :check_your_answers_flow?
        end
      end
    end

    private

    def operator_address_was_manually_entered?
      return false unless operator_address

      # We use the mode field to record whether the address was manually entered
      # and because it correlates to an enum, Activerecord magic gives us
      # my_address.manual?
      operator_address.manual?
    end

    def contact_address_was_manually_entered?
      return false unless contact_address

      contact_address.manual?
    end

    def site_address_was_manually_entered?
      return false unless site_address

      site_address.manual?
    end

    def site_address_was_entered?
      return false unless site_address

      site_address.lookup?
    end

    def reuse_address_for_site_location?
      return true if %w[operator_address_option contact_address_option].include? temp_reuse_address_for_site_location

      false
    end

    def should_edit?
      start_option == "edit"
    end

    def should_register_in_northern_ireland?
      location == "northern_ireland"
    end

    def should_register_in_scotland?
      location == "scotland"
    end

    def should_register_in_wales?
      location == "wales"
    end

    def skip_registration_number?
      return false if company_no_required?

      true
    end

    def skip_to_manual_address?
      address_finder_error
    end

    def companies_house_details_incorrect?
      temp_use_registered_company_details == false
    end

    def renewal_start_option?
      start_option == "reregister"
    end

    def check_your_answers_flow?
      temp_check_your_answers_flow == true
    end

    def paying_by_card?
      temp_payment_method == "card"
    end

    def payment_via_bank_transfer?
      temp_payment_method == "bank_transfer"
    end

    def proceed_with_selected_exemptions?
      temp_confirm_exemptions == true
    end

    def proceed_with_selected_farm_exemptions?
      temp_add_additional_non_farm_exemptions == false
    end

    def reselect_exemptions?
      temp_confirm_exemptions == false
    end

    def add_additional_non_farm_exemptions?
      temp_add_additional_non_farm_exemptions == true
    end

    def no_exemptions_selected?
      temp_exemptions.nil? || temp_exemptions.empty?
    end
  end
end
