class CreateTenants < ActiveRecord::Migration[7.0]
  def change
    create_table :tenants do |t|
      t.string :name, nil: false
      t.bigint :regional_tenant_id

      t.timestamps
    end
  end
end
