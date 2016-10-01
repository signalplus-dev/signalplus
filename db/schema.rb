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

ActiveRecord::Schema.define(version: 20160918195325) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "brands", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.integer  "streaming_tweet_pid", limit: 8
    t.boolean  "polling_tweets",                default: false
  end

  add_index "brands", ["polling_tweets"], name: "index_brands_on_polling_tweets", using: :btree
  add_index "brands", ["streaming_tweet_pid"], name: "index_brands_on_streaming_tweet_pid", using: :btree

  create_table "identities", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "brand_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "encrypted_token"
    t.string   "encrypted_secret"
    t.string   "user_name"
    t.string   "profile_image_url"
  end

  add_index "identities", ["brand_id"], name: "index_identities_on_brand_id", using: :btree
  add_index "identities", ["provider", "uid"], name: "index_identities_on_provider_and_uid", unique: true, using: :btree
  add_index "identities", ["user_id"], name: "index_identities_on_user_id", using: :btree

  create_table "listen_signals", force: :cascade do |t|
    t.integer  "brand_id"
    t.integer  "identity_id"
    t.text     "name"
    t.boolean  "active",          default: false, null: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "signal_type"
    t.datetime "expiration_date"
  end

  add_index "listen_signals", ["brand_id"], name: "index_listen_signals_on_brand_id", using: :btree
  add_index "listen_signals", ["identity_id"], name: "index_listen_signals_on_identity_id", using: :btree

  create_table "payment_handlers", force: :cascade do |t|
    t.integer  "brand_id"
    t.string   "provider"
    t.string   "token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "payment_handlers", ["brand_id"], name: "index_payment_handlers_on_brand_id", using: :btree

  create_table "promotional_tweets", force: :cascade do |t|
    t.text     "message"
    t.integer  "listen_signal_id"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.boolean  "status",             default: false, null: false
    t.string   "direct_upload_url",                  null: false
  end

  add_index "promotional_tweets", ["listen_signal_id"], name: "index_promotional_tweets_on_listen_signal_id", using: :btree

  create_table "response_groups", force: :cascade do |t|
    t.integer  "listen_signal_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "response_groups", ["listen_signal_id"], name: "index_response_groups_on_listen_signal_id", using: :btree

  create_table "responses", force: :cascade do |t|
    t.text     "message"
    t.string   "response_type"
    t.integer  "response_group_id"
    t.datetime "expiration_date"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "priority"
  end

  add_index "responses", ["response_group_id"], name: "index_responses_on_response_group_id", using: :btree

  create_table "subscription_plans", force: :cascade do |t|
    t.integer  "amount"
    t.string   "name"
    t.integer  "number_of_messages"
    t.string   "currency"
    t.string   "provider"
    t.string   "provider_id"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "description",        default: ""
  end

  create_table "subscriptions", force: :cascade do |t|
    t.integer  "brand_id"
    t.integer  "subscription_plan_id"
    t.string   "provider"
    t.string   "token"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.datetime "canceled_at"
  end

  add_index "subscriptions", ["brand_id"], name: "index_subscriptions_on_brand_id", unique: true, using: :btree
  add_index "subscriptions", ["canceled_at"], name: "index_subscriptions_on_canceled_at", using: :btree
  add_index "subscriptions", ["subscription_plan_id"], name: "index_subscriptions_on_subscription_plan_id", using: :btree

  create_table "twitter_direct_message_trackers", force: :cascade do |t|
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.integer  "last_recorded_tweet_id", limit: 8, default: 1
    t.integer  "since_id",               limit: 8, default: 1
    t.integer  "max_id",                 limit: 8
    t.integer  "brand_id"
  end

  add_index "twitter_direct_message_trackers", ["brand_id"], name: "index_twitter_direct_message_trackers_on_brand_id", unique: true, using: :btree

  create_table "twitter_responses", force: :cascade do |t|
    t.string   "to",                                       null: false
    t.date     "date",                                     null: false
    t.integer  "reply_tweet_id",     limit: 8
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.integer  "request_tweet_id",   limit: 8, default: 0, null: false
    t.integer  "brand_id"
    t.string   "reply_tweet_type"
    t.string   "request_tweet_type"
    t.integer  "listen_signal_id"
    t.integer  "response_id"
  end

  add_index "twitter_responses", ["brand_id"], name: "index_twitter_responses_on_brand_id", using: :btree
  add_index "twitter_responses", ["listen_signal_id"], name: "index_twitter_responses_on_listen_signal_id", using: :btree
  add_index "twitter_responses", ["response_id"], name: "index_twitter_responses_on_response_id", using: :btree

  create_table "twitter_trackers", force: :cascade do |t|
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.integer  "last_recorded_tweet_id", limit: 8, default: 1
    t.integer  "since_id",               limit: 8, default: 1
    t.integer  "max_id",                 limit: 8
    t.integer  "brand_id"
  end

  add_index "twitter_trackers", ["brand_id"], name: "index_twitter_trackers_on_brand_id", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",      null: false
    t.string   "encrypted_password",     default: "",      null: false
    t.string   "name"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,       null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.integer  "brand_id"
    t.string   "provider",               default: "email", null: false
    t.string   "uid",                    default: "",      null: false
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.json     "tokens"
  end

  add_index "users", ["brand_id"], name: "index_users_on_brand_id", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true, using: :btree

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",      null: false
    t.integer  "item_id",        null: false
    t.string   "event",          null: false
    t.string   "whodunnit"
    t.jsonb    "object"
    t.datetime "created_at"
    t.jsonb    "object_changes"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree
  add_index "versions", ["object"], name: "index_versions_on_object", using: :btree
  add_index "versions", ["object_changes"], name: "index_versions_on_object_changes", using: :btree

  add_foreign_key "identities", "brands"
  add_foreign_key "identities", "users"
  add_foreign_key "listen_signals", "brands"
  add_foreign_key "listen_signals", "identities"
  add_foreign_key "promotional_tweets", "listen_signals"
  add_foreign_key "response_groups", "listen_signals"
  add_foreign_key "responses", "response_groups"
  add_foreign_key "twitter_direct_message_trackers", "brands"
  add_foreign_key "twitter_responses", "brands"
  add_foreign_key "twitter_trackers", "brands"
  add_foreign_key "users", "brands"
end
