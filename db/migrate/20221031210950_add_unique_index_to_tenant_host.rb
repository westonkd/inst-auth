class AddUniqueIndexToTenantHost < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  def change
    add_index :tenant_hosts, %i[tenant_id host], unique: true, algorithm: :concurrently, if_not_exists: true
  end
end
