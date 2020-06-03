class AddDeregisteredOnToRegistrationExemption < ActiveRecord::Migration[4.2]
  def change
    add_column :registration_exemptions, :deregistered_on, :date
  end
end
