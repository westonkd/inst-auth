class AddIdentifierToConnection < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  def change
    add_column :connections, :identifier, :string, nil: false
    add_index :connections, :identifier, algorithm: :concurrently, if_not_exists: true, unique: true
  end
end
