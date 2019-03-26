class AddDeregisteredOnToRegistrationExemption < ActiveRecord::Migration
  def change
    add_column :registration_exemptions, :deregistered_on, :date
  end
end
