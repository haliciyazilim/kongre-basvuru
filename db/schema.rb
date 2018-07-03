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

ActiveRecord::Schema.define(version: 20170815134737) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "applicant_presentations", force: :cascade do |t|
    t.integer  "applicant_id"
    t.text     "purpose"
    t.text     "content"
    t.text     "audience"
    t.datetime "created_at",   precision: 6
    t.datetime "updated_at",   precision: 6
    t.integer  "season"
  end

  create_table "applicants", force: :cascade do |t|
    t.string   "name",                          limit: 255
    t.string   "surname",                       limit: 255
    t.string   "email",                         limit: 255
    t.string   "tckn",                          limit: 255
    t.date     "birthday"
    t.string   "phone",                         limit: 255
    t.string   "organization",                  limit: 255
    t.string   "occupation",                    limit: 255
    t.text     "address"
    t.string   "city",                          limit: 255
    t.string   "relation_to_high_intelligence", limit: 255
    t.string   "previous_attendances",          limit: 255
    t.string   "applicant_category",            limit: 255
    t.string   "applicant_type",                limit: 255
    t.datetime "created_at",                                precision: 6
    t.datetime "updated_at",                                precision: 6
    t.integer  "season"
  end

  create_table "attendances", force: :cascade do |t|
    t.integer "product_id"
  end

  create_table "card_numbers", force: :cascade do |t|
    t.integer "applicant_id"
    t.index ["applicant_id"], name: "index_card_numbers_on_applicant_id", unique: true, using: :btree
  end

  create_table "coupons", force: :cascade do |t|
    t.string   "code",         limit: 255
    t.float    "amount"
    t.integer  "season"
    t.string   "coupon_type",  limit: 255
    t.datetime "used_at",                  precision: 6
    t.datetime "created_at",               precision: 6
    t.datetime "updated_at",               precision: 6
    t.integer  "applicant_id"
    t.string   "email",        limit: 255
  end

  create_table "products", force: :cascade do |t|
    t.integer  "stock"
    t.integer  "price"
    t.string   "product_type", limit: 255
    t.string   "name",         limit: 255
    t.datetime "created_at",               precision: 6
    t.datetime "updated_at",               precision: 6
    t.integer  "max_stock",                              default: 100
    t.integer  "season"
  end

  create_table "receipt_products", force: :cascade do |t|
    t.integer "receipt_id"
    t.integer "product_id"
    t.integer "price"
  end

  create_table "receipts", force: :cascade do |t|
    t.integer  "applicant_id"
    t.integer  "price"
    t.boolean  "is_paid",                    default: false
    t.datetime "created_at",   precision: 6
    t.datetime "updated_at",   precision: 6
    t.string   "response"
  end

  create_table "workshops", force: :cascade do |t|
    t.datetime "start_at",                 precision: 6
    t.datetime "finish_at",                precision: 6
    t.string   "saloon",       limit: 255
    t.string   "moderator",    limit: 255
    t.integer  "product_id"
    t.boolean  "for_children",                           default: false
    t.index ["for_children"], name: "index_workshops_on_for_children", using: :btree
  end

end
