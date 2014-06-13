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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121029145852) do

  create_table "active_admin_comments", :force => true do |t|
    t.integer  "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "admin_roles", :force => true do |t|
    t.integer "admin_user_id"
    t.integer "role_id"
  end

  add_index "admin_roles", ["admin_user_id", "role_id"], :name => "index_admin_roles_on_admin_user_id_and_role_id"

  create_table "admin_users", :force => true do |t|
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

  create_table "area_codes", :force => true do |t|
    t.string   "area_code"
    t.string   "area_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bills", :force => true do |t|
    t.string   "amount"
    t.integer  "source_id"
    t.datetime "created_at_time"
    t.integer  "bill_id"
    t.integer  "pre_user_id"
    t.string   "uri"
    t.integer  "pre_authorization_id"
    t.integer  "booking_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bills", ["bill_id"], :name => "index_bills_on_bill_id"
  add_index "bills", ["booking_id"], :name => "index_bills_on_booking_id"
  add_index "bills", ["pre_authorization_id"], :name => "index_bills_on_pre_authorization_id"

  create_table "bookings", :force => true do |t|
    t.date     "pickup_date"
    t.datetime "pickup_time"
    t.date     "delivery_date"
    t.float    "surcharge",            :default => 0.0
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "special_instructions"
    t.integer  "items_count"
    t.string   "status",               :default => "Pending"
    t.float    "cost"
    t.string   "discount_code"
  end

  create_table "companies", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "address"
    t.string   "city"
    t.string   "postal_code", :limit => 10
  end

  create_table "discount_codes", :force => true do |t|
    t.string   "discount_code"
    t.string   "code_type"
    t.string   "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "start_date"
    t.datetime "end_date"
    t.float    "value"
  end

  create_table "items", :force => true do |t|
    t.string   "name"
    t.integer  "booking_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "price"
    t.integer  "quantity"
  end

  create_table "password_codes", :force => true do |t|
    t.string   "code"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payment_details", :force => true do |t|
    t.string   "card_type"
    t.date     "issue_date"
    t.string   "card_holder_name"
    t.date     "expiration_date"
    t.string   "security_code"
    t.text     "special_instructions"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "credit_card_number"
  end

  create_table "plans", :force => true do |t|
    t.string  "category", :limit => 30
    t.string  "name",     :limit => 20
    t.integer "price"
  end

  add_index "plans", ["category", "name"], :name => "index_plans_on_category_and_name", :unique => true

  create_table "pre_authorizations", :force => true do |t|
    t.integer  "pre_id"
    t.integer  "interval_length"
    t.string   "interval_unit"
    t.integer  "user_id"
    t.integer  "go_user_id"
    t.string   "max_amount"
    t.string   "uri"
    t.datetime "created_at_time"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pre_authorizations", ["pre_id"], :name => "index_pre_authorizations_on_pre_id"
  add_index "pre_authorizations", ["user_id"], :name => "index_pre_authorizations_on_user_id"

  create_table "price_list_categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "price_lists", :force => true do |t|
    t.string   "item_name"
    t.float    "price"
    t.integer  "price_list_category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_companies", :force => true do |t|
    t.integer  "user_id"
    t.integer  "company_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_companies", ["user_id", "company_id"], :name => "index_user_companies_on_user_id_and_company_id", :unique => true

  create_table "user_plans", :force => true do |t|
    t.integer "user_id"
    t.integer "plan_id"
    t.string  "subscription_id"
  end

  add_index "user_plans", ["subscription_id"], :name => "index_user_plans_on_subscription_id"
  add_index "user_plans", ["user_id", "plan_id"], :name => "index_user_plans_on_user_id_and_plan_id", :unique => true

  create_table "users", :force => true do |t|
    t.string   "title"
    t.string   "first_name"
    t.string   "surname"
    t.string   "city"
    t.string   "post_code"
    t.string   "home_number"
    t.string   "mobile_number"
    t.string   "login",                     :limit => 40
    t.string   "name",                      :limit => 100, :default => ""
    t.string   "email",                     :limit => 100
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token",            :limit => 40
    t.text     "address"
    t.datetime "remember_token_expires_at"
    t.string   "ref_id"
    t.string   "address_first"
    t.string   "address_last"
    t.boolean  "corporate",                                :default => false, :null => false
  end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

end
