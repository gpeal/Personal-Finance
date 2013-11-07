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

ActiveRecord::Schema.define(version: 20131106050632) do

  create_table "closing_prices", force: true do |t|
    t.float   "price"
    t.date    "date"
    t.integer "security_id"
  end

  add_index "closing_prices", ["security_id"], name: "index_closing_prices_on_security_id", using: :btree

  create_table "data_points", force: true do |t|
    t.integer "security_id"
    t.integer "data_type_id"
    t.hstore  "data"
  end

  create_table "data_types", force: true do |t|
    t.string "name"
    t.string "description"
  end

  create_table "securities", force: true do |t|
    t.string "ticker",      null: false
    t.string "name",        null: false
    t.string "description"
  end

  create_table "task_statuses", force: true do |t|
    t.string "status"
  end

  create_table "task_types", force: true do |t|
    t.string "name"
    t.string "description"
    t.string "queue",       default: "q"
    t.string "klass"
  end

  create_table "tasks", force: true do |t|
    t.integer "task_status_id", default: 1
    t.integer "task_type_id",               null: false
    t.hstore  "info"
  end

end
