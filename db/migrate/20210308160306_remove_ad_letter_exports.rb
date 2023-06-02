# frozen_string_literal: true

class RemoveAdLetterExports < ActiveRecord::Migration[6.0]
  def change
    drop_table :ad_confirmation_letters_exports, if_exists: true
    drop_table :ad_renewal_letters_exports, if_exists: true
  end
end
