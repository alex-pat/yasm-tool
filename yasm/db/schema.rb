# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160814132516) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "awarded_badges", force: :cascade do |t|
    t.integer  "awardee_id"
    t.string   "awardee_type"
    t.string   "badge_code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["awardee_id", "awardee_type", "badge_code"], name: "awarded_badges_awardee_badge_index", unique: true, using: :btree
  end

  create_table "blocks", force: :cascade do |t|
    t.string   "position"
    t.integer  "page_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["page_id"], name: "index_blocks_on_page_id", using: :btree
  end

  create_table "components", force: :cascade do |t|
    t.string   "kind"
    t.text     "content"
    t.integer  "order"
    t.integer  "block_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["block_id"], name: "index_components_on_block_id", using: :btree
  end

  create_table "pages", force: :cascade do |t|
    t.string   "title"
    t.string   "layout"
    t.string   "url"
    t.integer  "site_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["site_id"], name: "index_pages_on_site_id", using: :btree
  end

  create_table "pictures", force: :cascade do |t|
    t.string   "public_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_pictures_on_user_id", using: :btree
  end

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.string   "resource_type"
    t.integer  "resource_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id", using: :btree
    t.index ["name"], name: "index_roles_on_name", using: :btree
  end

  create_table "sites", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.string   "theme"
    t.integer  "user_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "logo"
    t.index ["user_id"], name: "index_sites_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "username"
    t.string   "avatar"
    t.string   "provider"
    t.string   "uid"
    t.text     "about"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "site_id"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id", using: :btree
  end

  add_foreign_key "blocks", "pages"
  add_foreign_key "components", "blocks"
  add_foreign_key "pages", "sites"
  add_foreign_key "pictures", "users"
  add_foreign_key "sites", "users"
end
