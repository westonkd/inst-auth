# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_10_31_171923) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "communication_channels", force: :cascade do |t|
    t.string "path"
    t.string "path_type"
    t.string "workflow_state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_communication_channels_on_user_id"
  end

  create_table "tenant_hosts", force: :cascade do |t|
    t.string "host"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "tenant_id"
    t.index ["host"], name: "index_tenant_hosts_on_host"
  end

  create_table "tenant_users", force: :cascade do |t|
    t.string "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.bigint "tenant_id"
    t.index ["tenant_id"], name: "index_tenant_users_on_tenant_id"
    t.index ["user_id"], name: "index_tenant_users_on_user_id"
  end

  create_table "tenants", force: :cascade do |t|
    t.string "name"
    t.bigint "regional_tenant_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.text "sub"
    t.text "name"
    t.text "given_name"
    t.text "family_name"
    t.text "middle_name"
    t.text "nickname"
    t.text "preferred_username"
    t.text "profile"
    t.text "picture"
    t.text "website"
    t.datetime "birthdate"
    t.string "zoneinfo"
    t.string "locale"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sub"], name: "index_users_on_sub"
  end

  add_foreign_key "tenant_users", "tenants"
  add_foreign_key "tenant_users", "users"
end
