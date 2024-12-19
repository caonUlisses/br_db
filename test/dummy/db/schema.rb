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

ActiveRecord::Schema[8.0].define(version: 2024_12_19_170841) do
  create_table "br_db_cities", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.string "state_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "br_db_cnaes", force: :cascade do |t|
    t.string "code"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "br_db_companies", force: :cascade do |t|
    t.string "cnpj"
    t.string "name"
    t.string "legal_name"
    t.datetime "since"
    t.string "main_cnae"
    t.string "secondary_cnae"
    t.string "street_name"
    t.string "address_number"
    t.string "address_additional_info"
    t.string "neighborhood_name"
    t.string "zip_code"
    t.string "state_code"
    t.string "city_name"
    t.string "main_phone"
    t.string "secondary_phone"
    t.string "additional_phone"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "br_db_countries", force: :cascade do |t|
    t.string "name"
    t.string "iso_2"
    t.string "iso_3"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "br_db_states", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "br_db_zip_codes", force: :cascade do |t|
    t.string "zip_code"
    t.string "street_name"
    t.string "street_additional_info"
    t.string "neighborhood_name"
    t.string "city_name"
    t.string "city_code"
    t.string "state_code"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end
end
