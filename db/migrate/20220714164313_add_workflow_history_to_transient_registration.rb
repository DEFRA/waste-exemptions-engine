# frozen_string_literal: true

class AddWorkflowHistoryToTransientRegistration < ActiveRecord::Migration[6.1]
  def change
    add_column :transient_registrations, :workflow_history, :text, array: true, default: []
  end
end
