class CreateUsers < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  def change
    create_table :users do |t|
      t.text :sub, nil: false
      t.text :name, nil: false
      t.text :given_name
      t.text :family_name
      t.text :middle_name
      t.text :nickname
      t.text :preferred_username
      t.text :profile
      t.text :picture
      t.text :website
      t.datetime :birthdate
      t.string :zoneinfo
      t.string :locale

      t.timestamps
    end

    add_index :users, :sub, algorithm: :concurrently, if_not_exists: true
  end
end
