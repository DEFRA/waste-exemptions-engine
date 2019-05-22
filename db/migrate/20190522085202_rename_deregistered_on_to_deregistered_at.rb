class RenameDeregisteredOnToDeregisteredAt < ActiveRecord::Migration
  def change
    rename_column :registration_exemptions, :deregistered_on, :deregistered_at
  end
end
