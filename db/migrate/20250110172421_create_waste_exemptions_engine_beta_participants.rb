# frozen_string_literal: true

class CreateWasteExemptionsEngineBetaParticipants < ActiveRecord::Migration[7.1]
  def change
    create_table :beta_participants do |t|
      t.string :reg_number
      t.string :email
      t.string :token
      t.datetime :invited_at
      t.boolean :opted_in
      t.references :registration, polymorphic: true

      t.timestamps
    end
  end
end
