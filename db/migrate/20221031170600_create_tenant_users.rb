class CreateTenantUsers < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  def change
    create_table :tenant_users do |t|
      t.string :role, nil: false

      t.timestamps
    end

    add_reference :tenant_users, :user, type: :bigint, foreign_key: true, index: true, if_not_exists: true
    add_reference :tenant_users, :tenant, type: :bigint, foreign_key: true, index: true, if_not_exists: true
  end
end
