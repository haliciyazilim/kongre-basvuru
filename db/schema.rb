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

ActiveRecord::Schema.define(version: 20150701120116) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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

  create_table "presentations", force: true do |t|
    t.integer  "applicant_id"
    t.text     "purpose"
    t.text     "content"
    t.text     "audience"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
