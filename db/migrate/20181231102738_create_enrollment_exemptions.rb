# frozen_string_literal: true

class CreateEnrollmentExemptions < ActiveRecord::Migration
  def change
    create_table :enrollment_exemptions do |t|
      t.belongs_to :enrollment, index: true
      t.belongs_to :exemption, index: true

      t.timestamps null: false
    end
  end
end
