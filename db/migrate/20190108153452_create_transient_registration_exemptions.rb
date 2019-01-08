# frozen_string_literal: true

class CreateTransientRegistrationExemptions < ActiveRecord::Migration
  def change
    create_table :transient_registration_exemptions do |t|
      t.string :state
      t.date :registered_on
      t.date :expires_on
      t.belongs_to :transient_registration, index: { name: "index_trans_reg_exemptions_on_transient_registration_id" }
      t.belongs_to :exemption, index: true

      t.timestamps null: false
    end
  end
end
