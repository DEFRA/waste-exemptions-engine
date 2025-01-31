# frozen_string_literal: true

class AddSelectedPaymentMethodToBetaParticipants < ActiveRecord::Migration[7.1]
  def change
    add_column :beta_participants, :selected_payment_method, :string, default: nil
  end
end
