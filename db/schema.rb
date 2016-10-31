# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20161031173722) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "favorits", force: :cascade do |t|
    t.string   "url",         limit: 255,                 null: false
    t.string   "name",        limit: 255,                 null: false
    t.text     "body"
    t.text     "description"
    t.boolean  "link",                    default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "slug",        limit: 255
  end

  add_index "favorits", ["slug"], name: "index_favorits_on_slug", unique: true, using: :btree
  add_index "favorits", ["user_id"], name: "index_favorits_on_user_id", using: :btree

  create_table "feed_images", force: :cascade do |t|
    t.text     "image"
    t.integer  "feed_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "feeds", force: :cascade do |t|
    t.string   "title",       limit: 255
    t.text     "url"
    t.text     "description"
    t.text     "body"
    t.integer  "site_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "date"
    t.string   "slug",        limit: 255
  end

  add_index "feeds", ["slug"], name: "index_feeds_on_slug", unique: true, using: :btree

  create_table "sites", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "url",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "slug",       limit: 255
    t.boolean  "error",                  default: false, null: false
  end

  add_index "sites", ["slug"], name: "index_sites_on_slug", unique: true, using: :btree
  add_index "sites", ["user_id"], name: "index_sites_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "",       null: false
    t.string   "encrypted_password",     limit: 255, default: "",       null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,        null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "rsskey",                 limit: 255
    t.string   "time_zone",                          default: "Moscow", null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
