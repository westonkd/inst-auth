class ChangeIdentifierIndexOnConnection < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  def change
    remove_index :connections, :identifier
    add_index :connections, :identifier, algorithm: :concurrently, if_not_exists: true
  end
end
