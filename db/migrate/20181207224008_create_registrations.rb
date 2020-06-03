# frozen_string_literal: true

class CreateRegistrations < ActiveRecord::Migration[4.2]
  # rubocop:disable Metrics/MethodLength
  def change
    create_table(:registrations) do |t|
      t.string :reference
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
      t.timestamps null: false

      t.index :reference, unique: true
    end
  end
  # rubocop:enable Metrics/MethodLength
end
