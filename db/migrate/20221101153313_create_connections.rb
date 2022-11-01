class CreateConnections < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  def change
    create_table :connections do |t|
      t.text :issuer, nil: false
      t.text :authorization_endpoint, nil: false
      t.text :token_endpoint
      t.text :userinfo_endpoint
      t.text :jwks_uri
      t.text :registration_endpoint
      t.string :name, nil: false
      t.string :scopes_supported, array: true, default: []
      t.string :response_types_supported, array: true, default: []
      t.string :type, nil: false

      t.timestamps
    end

    add_reference :connections, :tenant, type: :bigint, foreign_key: true, index: true, if_not_exists: true
    add_index :connections, %i[issuer authorization_endpoint], unique: true, algorithm: :concurrently, if_not_exists: true
  end
end
