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

ActiveRecord::Schema.define(version: 20150907125157) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "applicant_presentations", force: true do |t|
    t.integer  "applicant_id"
    t.text     "purpose"
    t.text     "content"
    t.text     "audience"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "applicants", force: true do |t|
    t.string   "name"
    t.string   "surname"
    t.string   "email"
    t.string   "tckn"
    t.date     "birthday"
    t.string   "phone"
    t.string   "organization"
    t.string   "occupation"
    t.text     "address"
    t.string   "city"
    t.string   "relation_to_high_intelligence"
    t.string   "previous_attendances"
    t.string   "applicant_category"
    t.string   "applicant_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "attendances", force: true do |t|
    t.integer "product_id"
  end

  create_table "card_numbers", force: true do |t|
    t.integer "applicant_id"
  end

  add_index "card_numbers", ["applicant_id"], name: "index_card_numbers_on_applicant_id", unique: true, using: :btree

  create_table "products", force: true do |t|
    t.integer  "stock"
    t.integer  "price"
    t.string   "product_type"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "max_stock",    default: 100
  end

  create_table "receipt_products", force: true do |t|
    t.integer "receipt_id"
    t.integer "product_id"
    t.integer "price"
  end

  create_table "receipts", force: true do |t|
    t.integer  "applicant_id"
    t.integer  "price"
    t.boolean  "is_paid",      default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "workshops", force: true do |t|
    t.datetime "start_at"
    t.datetime "finish_at"
    t.string   "saloon"
    t.string   "moderator"
    t.integer  "product_id"
    t.boolean  "for_children", default: false
  end

  add_index "workshops", ["for_children"], name: "index_workshops_on_for_children", using: :btree

end
