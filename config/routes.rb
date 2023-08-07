# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
WasteExemptionsEngine::Engine.routes.draw do
  resources :start_forms,
            only: %i[new create],
            path: "start",
            path_names: { new: "" }

  scope "/:token" do
    resources :contact_agency_forms,
              only: %i[new create],
              path: "contact-agency",
              path_names: { new: "" }

    resources :location_forms,
              only: %i[new create],
              path: "location",
              path_names: { new: "" }

    resources :register_in_northern_ireland_forms,
              only: %i[new create],
              path: "register-in-northern-ireland",
              path_names: { new: "" }

    resources :register_in_scotland_forms,
              only: %i[new create],
              path: "register-in-scotland",
              path_names: { new: "" }

    resources :register_in_wales_forms,
              only: %i[new create],
              path: "register-in-wales",
              path_names: { new: "" }

    resources :applicant_name_forms,
              only: %i[new create],
              path: "applicant-name",
              path_names: { new: "" }

    resources :applicant_phone_forms,
              only: %i[new create],
              path: "applicant-phone",
              path_names: { new: "" }

    resources :applicant_email_forms,
              only: %i[new create],
              path: "applicant-email",
              path_names: { new: "" }

    resources :business_type_forms,
              only: %i[new create],
              path: "business-type",
              path_names: { new: "" }

    resources :registration_number_forms,
              only: %i[new create],
              path: "registration-number",
              path_names: { new: "" }

    resources :check_registered_name_and_address_forms,
              only: %i[new create],
              path: "check-registered-name-and-address",
              path_names: { new: "" }

    resources :incorrect_company_forms,
              only: %i[new create],
              path: "incorrect-company",
              path_names: { new: "" }

    resources :main_people_forms,
              only: %i[new create],
              path: "main-people",
              path_names: { new: "" } do
                delete "delete_person/:id",
                       to: "main_people_forms#delete_person",
                       as: "delete_person",
                       on: :collection
              end

    resources :operator_name_forms,
              only: %i[new create],
              path: "operator-name",
              path_names: { new: "" }

    resources :operator_postcode_forms,
              only: %i[new create],
              path: "operator-postcode",
              path_names: { new: "" } do
                get "skip_to_manual_address",
                    to: "operator_postcode_forms#skip_to_manual_address",
                    as: "skip_to_manual_address",
                    on: :collection
              end

    resources :operator_address_lookup_forms,
              only: %i[new create],
              path: "operator-address-lookup",
              path_names: { new: "" } do
                get "skip_to_manual_address",
                    to: "operator_address_lookup_forms#skip_to_manual_address",
                    as: "skip_to_manual_address",
                    on: :collection
              end

    resources :operator_address_manual_forms,
              only: %i[new create],
              path: "operator-address-manual",
              path_names: { new: "" }

    resources :check_contact_name_forms,
              only: %i[new create],
              path: "check-contact-name",
              path_names: { new: "" }

    resources :contact_name_forms,
              only: %i[new create],
              path: "contact-name",
              path_names: { new: "" }

    resources :contact_position_forms,
              only: %i[new create],
              path: "contact-position",
              path_names: { new: "" }

    resources :check_contact_phone_forms,
              only: %i[new create],
              path: "check-contact-phone",
              path_names: { new: "" }

    resources :contact_phone_forms,
              only: %i[new create],
              path: "contact-phone",
              path_names: { new: "" }

    resources :check_contact_email_forms,
              only: %i[new create],
              path: "check-contact-email",
              path_names: { new: "" }

    resources :contact_email_forms,
              only: %i[new create],
              path: "contact-email",
              path_names: { new: "" }

    resources :check_contact_address_forms,
              only: %i[new create],
              path: "check-contact-address",
              path_names: { new: "" }

    resources :contact_postcode_forms,
              only: %i[new create],
              path: "contact-postcode",
              path_names: { new: "" } do
                get "skip_to_manual_address",
                    to: "contact_postcode_forms#skip_to_manual_address",
                    as: "skip_to_manual_address",
                    on: :collection
              end

    resources :contact_address_lookup_forms,
              only: %i[new create],
              path: "contact-address-lookup",
              path_names: { new: "" } do
                get "skip_to_manual_address",
                    to: "contact_address_lookup_forms#skip_to_manual_address",
                    as: "skip_to_manual_address",
                    on: :collection
              end

    resources :contact_address_manual_forms,
              only: %i[new create],
              path: "contact-address-manual",
              path_names: { new: "" }

    resources :on_a_farm_forms,
              only: %i[new create],
              path: "on-a-farm",
              path_names: { new: "" }

    resources :is_a_farmer_forms,
              only: %i[new create],
              path: "is-a-farmer",
              path_names: { new: "" }

    resources :site_grid_reference_forms,
              only: %i[new create],
              path: "site-grid-reference",
              path_names: { new: "" } do
                get "skip_to_address/:token",
                    to: "site_grid_reference_forms#skip_to_address",
                    as: "skip_to_address",
                    on: :collection
              end

    resources :check_site_address_forms,
              only: %i[new create],
              path: "check-site-address",
              path_names: { new: "" }

    resources :site_postcode_forms,
              only: %i[new create],
              path: "site-postcode",
              path_names: { new: "" }

    resources :site_address_lookup_forms,
              only: %i[new create],
              path: "site-address-lookup",
              path_names: { new: "" }

    resources :exemptions_forms,
              only: %i[new create],
              path: "exemptions",
              path_names: { new: "" }

    resources :renew_exemptions_forms,
              only: %i[new create],
              path: "renew-exemptions",
              path_names: { new: "" }

    resources :renew_no_exemptions_forms,
              only: %i[new],
              path: "renew-no-exemptions",
              path_names: { new: "" }

    resources :check_your_answers_forms,
              only: %i[new create],
              path: "check-your-answers",
              path_names: { new: "" }

    resources :declaration_forms,
              only: %i[new create],
              path: "declaration",
              path_names: { new: "" }

    resources :registration_complete_forms,
              only: %i[new create],
              path: "registration-complete",
              path_names: { new: "" }

    resources :registration_lookup_forms,
              only: %i[new create],
              path: "registration-lookup",
              path_names: { new: "" }

    resources :registration_lookup_email_forms,
              only: %i[new create],
              path: "registration-lookup-email",
              path_names: { new: "" }

    resources :registration_lookup_complete_forms,
              only: %i[new],
              path: "registration-lookup-complete",
              path_names: { new: "" }

    # Editing: Back office
    resources :back_office_edit_forms,
              only: %i[new create],
              path: "edit",
              path_names: { new: "" } do
                get "applicant_name",
                    to: "back_office_edit_forms#edit_applicant_name",
                    as: "applicant_name",
                    on: :collection

                get "applicant_phone",
                    to: "back_office_edit_forms#edit_applicant_phone",
                    as: "applicant_phone",
                    on: :collection

                get "applicant_email",
                    to: "back_office_edit_forms#edit_applicant_email",
                    as: "applicant_email",
                    on: :collection

                get "main_people",
                    to: "back_office_edit_forms#edit_main_people",
                    as: "main_people",
                    on: :collection

                get "registration_number",
                    to: "back_office_edit_forms#edit_registration_number",
                    as: "registration_number",
                    on: :collection

                get "operator_name",
                    to: "back_office_edit_forms#edit_operator_name",
                    as: "operator_name",
                    on: :collection

                get "operator_postcode",
                    to: "back_office_edit_forms#edit_operator_postcode",
                    as: "operator_postcode",
                    on: :collection

                get "contact_name",
                    to: "back_office_edit_forms#edit_contact_name",
                    as: "contact_name",
                    on: :collection

                get "contact_position",
                    to: "back_office_edit_forms#edit_contact_position",
                    as: "contact_position",
                    on: :collection

                get "contact_phone",
                    to: "back_office_edit_forms#edit_contact_phone",
                    as: "contact_phone",
                    on: :collection

                get "contact_email",
                    to: "back_office_edit_forms#edit_contact_email",
                    as: "contact_email",
                    on: :collection

                get "contact_postcode",
                    to: "back_office_edit_forms#edit_contact_postcode",
                    as: "contact_postcode",
                    on: :collection

                get "on_a_farm",
                    to: "back_office_edit_forms#edit_on_a_farm",
                    as: "on_a_farm",
                    on: :collection

                get "edit_exemptions",
                    to: "back_office_edit_forms#edit_exemptions",
                    as: "edit_exemptions",
                    on: :collection

                get "is_a_farmer",
                    to: "back_office_edit_forms#edit_is_a_farmer",
                    as: "is_a_farmer",
                    on: :collection

                get "site_grid_reference",
                    to: "back_office_edit_forms#edit_site_grid_reference",
                    as: "site_grid_reference",
                    on: :collection

                get "cancel",
                    to: "back_office_edit_forms#cancel",
                    as: "cancel",
                    on: :collection
              end

    resources :back_office_edit_complete_forms,
              only: %i[new create],
              path: "edit-complete",
              path_names: { new: "" }

    resources :confirm_back_office_edit_cancelled_forms,
              only: %i[new create],
              path: "confirm-edit-cancelled",
              path_names: { new: "" }

    resources :back_office_edit_cancelled_forms,
              only: %i[new create],
              path: "edit-cancelled",
              path_names: { new: "" }

    # Editing: Front office
    resources :front_office_edit_forms,
              only: %i[new create],
              path: "fo_edit",
              path_names: { new: "" } do
                get "contact_name",
                    to: "front_office_edit_forms#edit_contact_name",
                    as: "contact_name",
                    on: :collection

                get "contact_phone",
                    to: "front_office_edit_forms#edit_contact_phone",
                    as: "contact_phone",
                    on: :collection

                get "contact_email",
                    to: "front_office_edit_forms#edit_contact_email",
                    as: "contact_email",
                    on: :collection

                get "exemptions",
                    to: "front_office_edit_forms#edit_exemptions",
                    as: "edit_exemptions",
                    on: :collection
              end

    resources :front_office_edit_declaration_forms,
              only: %i[new create],
              path: "front-office-edit-declaration",
              path_names: { new: "" }

    resources :front_office_edit_complete_forms,
              only: %i[new create],
              path: "front-office-edit-complete",
              path_names: { new: "" }

    resources :front_office_edit_complete_no_change_forms,
              only: %i[new create],
              path: "front-office-edit-complete-no-changes",
              path_names: { new: "" }

    # Renewing
    resources :renewal_start_forms,
              only: %i[new create],
              path: "renewal-start",
              path_names: { new: "" }

    resources :cannot_renew_type_change_forms,
              only: %i[new create],
              path: "cannot-renew-type-change",
              path_names: { new: "" }

    resources :renew_with_changes_forms,
              only: %i[new create],
              path: "renew-with-changes",
              path_names: { new: "" }

    resources :renew_without_changes_forms,
              only: %i[new create],
              path: "renew-without-changes",
              path_names: { new: "" }

    resources :renewal_complete_forms,
              only: %i[new create],
              path: "renewal-complete",
              path_names: { new: "" }

    get "/back", to: "forms#go_back", as: "go_back_forms"

    # Deregistering
    resources :edit_exemptions_forms,
              only: %i[new create],
              path: "edit-exemptions",
              path_names: { new: "" }

    resources :confirm_edit_exemptions_forms,
              only: %i[new create],
              path: "confirm-edit-exemptions",
              path_names: { new: "" }

    resources :confirm_no_exemption_changes_forms,
              only: %i[new create],
              path: "confirm-no-exemption-changes",
              path_names: { new: "" }

    resources :edit_exemptions_declaration_forms,
              only: %i[new create],
              path: "edit-exemptions-declaration",
              path_names: { new: "" }

    resources :deregistration_complete_full_forms,
              only: %i[new],
              path: "deregistration-complete-full",
              path_names: { new: "" }

    resources :deregistration_complete_partial_forms,
              only: %i[new],
              path: "deregistration-complete-partial",
              path_names: { new: "" }

    resources :deregistration_complete_no_change_forms,
              only: %i[new],
              path: "deregistration-complete-no-change",
              path_names: { new: "" }

  end

  # See http://patrickperey.com/railscast-053-handling-exceptions/
  get "(errors)/:status",
      to: "errors#show",
      constraints: { status: /\d{3}/ },
      as: "error"

  get "/renew/:token",
      constraints: { token: /.*/ },
      to: "renews#new",
      as: "renew"

  # Start a front-end editing session via magic link token
  get "/edit_registration/:edit_token",
      constraints: { edit_token: /.*/ },
      to: "front_office_edit_forms#validate_edit_token",
      as: "validate_edit_token"

  # Static pages with HighVoltage
  resources :pages, only: [:show], controller: "pages"

  mount DefraRubyEmail::Engine => "/email"
end
# rubocop:enable Metrics/BlockLength
