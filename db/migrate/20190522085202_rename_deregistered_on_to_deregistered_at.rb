class RenameDeregisteredOnToDeregisteredAt < ActiveRecord::Migration[4.2]
  def change
    rename_column :registration_exemptions, :deregistered_on, :deregistered_at
  end
end
