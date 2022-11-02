class AddAuthorizationHostToConnection < ActiveRecord::Migration[7.0]
  def change
    add_column :connections, :authorization_host, :string
  end
end
