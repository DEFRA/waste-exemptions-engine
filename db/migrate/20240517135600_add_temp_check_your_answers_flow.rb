# frozen_string_literal: true

class AddTempCheckYourAnswersFlow < ActiveRecord::Migration[7.1]
  def up
    add_column :transient_registrations, :temp_check_your_answers_flow, :boolean, default: nil
  end

  def down
    remove_column :transient_registrations, :temp_check_your_answers_flow
  end
end
