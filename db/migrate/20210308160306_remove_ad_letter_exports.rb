class RemoveAdLetterExports < ActiveRecord::Migration[6.0]
  def change
    drop_table :ad_confirmation_letters_exports
    drop_table :ad_renewal_letters_exports
  end
end
