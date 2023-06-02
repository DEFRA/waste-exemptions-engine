# frozen_string_literal: true

class CreateTransientRegistrations < ActiveRecord::Migration[4.2]
  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize, Metrics/BlockLength
  def change
    create_table :transient_registrations do |t|
      t.string :token
      t.string :reference
      t.string :workflow_state
      t.string :start_option
      t.string :location
      t.string :applicant_first_name
      t.string :applicant_last_name
      t.string :applicant_phone
      t.string :applicant_email
      t.string :business_type
      t.string :operator_name
      t.string :company_no
      t.string :contact_first_name
      t.string :contact_last_name
      t.string :contact_position
      t.string :contact_phone
      t.string :contact_email
      t.boolean :is_a_farm
      t.boolean :on_a_farm
      t.boolean :declaration
      t.string :temp_operator_postcode
      t.string :temp_contact_postcode
      t.string :temp_site_postcode
      t.string :temp_grid_reference
      t.text :temp_site_description
      t.boolean :address_finder_error, default: false
      t.timestamps null: false

      t.index :token, unique: true
      t.index :reference, unique: true
    end
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize, Metrics/BlockLength
end
