class RemoveUniqueIndexFromConnections < ActiveRecord::Migration[7.0]
  def change
    remove_index :connections, %i[issuer authorization_endpoint]
  end
end
