class AddDeregistrationMessageToRegistrationExemption < ActiveRecord::Migration
  def change
    add_column :registration_exemptions, :deregistration_message, :text
  end
end
