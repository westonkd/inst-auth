class AddTenantToUser < ActiveRecord::Migration[7.0]
  def change
    add_reference :users, :tenant, type: :bigint, foreign_key: true, index: true, if_not_exists: true
  end
end
