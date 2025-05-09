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

ActiveRecord::Schema[8.0].define(version: 2025_04_19_180110) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "sessions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "client_id"
    t.index ["client_id"], name: "index_sessions_on_client_id"
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "touristic_visits", force: :cascade do |t|
    t.bigint "visited_city_id", null: false
    t.datetime "travel_date"
    t.string "rating"
    t.text "review"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_touristic_visits_on_user_id"
    t.index ["visited_city_id"], name: "index_touristic_visits_on_visited_city_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "api_token"
    t.index ["api_token"], name: "index_users_on_api_token", unique: true
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  create_table "visited_cities", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "visited_country_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["visited_country_id"], name: "index_visited_cities_on_visited_country_id"
  end

  create_table "visited_countries", force: :cascade do |t|
    t.string "name", null: false
    t.string "country_code", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_visited_countries_on_user_id"
  end

  add_foreign_key "sessions", "users"
  add_foreign_key "touristic_visits", "users"
  add_foreign_key "touristic_visits", "visited_cities"
  add_foreign_key "visited_cities", "visited_countries"
  add_foreign_key "visited_countries", "users"
end
