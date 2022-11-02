class CreateApplications < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  def change
    create_table :applications do |t|
      t.string :name, nil: false
      t.text :description, nil: false
      t.string :client_id, nil: false
      t.string :client_secret, nil: false
      t.string :client_secret_iv
      t.string :application_type, required: true
      t.string :redirect_uris, array: true, default: []
      t.text :logo

      t.timestamps
    end

    add_reference :applications, :tenant, type: :bigint, foreign_key: true, index: true, if_not_exists: true
    add_index :applications, :client_id, algorithm: :concurrently, if_not_exists: true, unique: true
  end
end
