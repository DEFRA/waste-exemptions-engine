# frozen_string_literal: true

class AddViewCertificateTokenAndCreatedAtToRegistrations < ActiveRecord::Migration[7.1]
  def change
    add_column :registrations, :view_certificate_token, :string
    add_column :registrations, :view_certificate_token_created_at, :datetime
  end
end
