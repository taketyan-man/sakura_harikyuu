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

ActiveRecord::Schema[7.0].define(version: 2023_07_04_074736) do
  create_table "booking_dates", force: :cascade do |t|
    t.string "tell"
    t.date "day"
    t.integer "time"
    t.integer "menu"
    t.string "date_time"
    t.string "name"
    t.string "s_time"
    t.string "e_time"
    t.integer "option"
  end

  create_table "hosts", force: :cascade do |t|
    t.string "password_digest"
  end

end
