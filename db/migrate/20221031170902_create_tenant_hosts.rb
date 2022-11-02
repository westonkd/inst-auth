class CreateTenantHosts < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  def change
    create_table :tenant_hosts do |t|
      t.string :host, nil: false

      t.timestamps
    end

    add_reference :tenant_hosts, :tenant, type: :bigint, foreign_key: false, index: false, if_not_exists: true
    add_index :tenant_hosts, :host, algorithm: :concurrently, if_not_exists: true
  end
end
