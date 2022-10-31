class CreateCommunicationChannels < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  def change
    create_table :communication_channels do |t|
      t.string :path, nil: false
      t.string :path_type, nil: false
      t.string :workflow_state, nil: false

      t.timestamps
    end

    add_reference :communication_channels, :user, type: :bigint, foreign_key: false, index: true, if_not_exists: true
  end
end
