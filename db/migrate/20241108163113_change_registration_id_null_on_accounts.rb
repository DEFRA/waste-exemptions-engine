class ChangeRegistrationIdNullOnAccounts < ActiveRecord::Migration[7.1]
  def change
    change_column_null :accounts, :registration_id, true
  end
end
