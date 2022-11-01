class ChangeConnectionTypeName < ActiveRecord::Migration[7.0]
  def change
    rename_column :connections, :type, :connection_type
  end
end
