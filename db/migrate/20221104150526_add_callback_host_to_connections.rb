class AddCallbackHostToConnections < ActiveRecord::Migration[7.0]
  def change
    add_column :connections, :callback_host, :string
  end
end
