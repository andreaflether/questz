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

ActiveRecord::Schema.define(version: 2021_07_31_162123) do

  create_table "activities", force: :cascade do |t|
    t.string "trackable_type"
    t.integer "trackable_id"
    t.string "owner_type"
    t.integer "owner_id"
    t.string "key"
    t.text "parameters"
    t.string "recipient_type"
    t.integer "recipient_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_id", "owner_type"], name: "index_activities_on_owner_id_and_owner_type"
    t.index ["owner_type", "owner_id"], name: "index_activities_on_owner_type_and_owner_id"
    t.index ["recipient_id", "recipient_type"], name: "index_activities_on_recipient_id_and_recipient_type"
    t.index ["recipient_type", "recipient_id"], name: "index_activities_on_recipient_type_and_recipient_id"
    t.index ["trackable_id", "trackable_type"], name: "index_activities_on_trackable_id_and_trackable_type"
    t.index ["trackable_type", "trackable_id"], name: "index_activities_on_trackable_type_and_trackable_id"
  end

  create_table "answers", force: :cascade do |t|
    t.boolean "chosen", default: false
    t.text "body", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "question_id"
    t.integer "user_id"
    t.index ["question_id"], name: "index_answers_on_question_id"
    t.index ["user_id"], name: "index_answers_on_user_id"
  end

  create_table "follows", force: :cascade do |t|
    t.string "followable_type", null: false
    t.integer "followable_id", null: false
    t.string "follower_type", null: false
    t.integer "follower_id", null: false
    t.boolean "blocked", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["followable_id", "followable_type"], name: "fk_followables"
    t.index ["followable_type", "followable_id"], name: "index_follows_on_followable_type_and_followable_id"
    t.index ["follower_id", "follower_type"], name: "fk_follows"
    t.index ["follower_type", "follower_id"], name: "index_follows_on_follower_type_and_follower_id"
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_type", "sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_type_and_sluggable_id"
  end

  create_table "impressions", force: :cascade do |t|
    t.string "impressionable_type"
    t.integer "impressionable_id"
    t.integer "user_id"
    t.string "controller_name"
    t.string "action_name"
    t.string "view_name"
    t.string "request_hash"
    t.string "ip_address"
    t.string "session_hash"
    t.text "message"
    t.text "referrer"
    t.text "params"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["controller_name", "action_name", "ip_address"], name: "controlleraction_ip_index"
    t.index ["controller_name", "action_name", "request_hash"], name: "controlleraction_request_index"
    t.index ["controller_name", "action_name", "session_hash"], name: "controlleraction_session_index"
    t.index ["impressionable_type", "impressionable_id", "ip_address"], name: "poly_ip_index"
    t.index ["impressionable_type", "impressionable_id", "params"], name: "poly_params_request_index"
    t.index ["impressionable_type", "impressionable_id", "request_hash"], name: "poly_request_index"
    t.index ["impressionable_type", "impressionable_id", "session_hash"], name: "poly_session_index"
    t.index ["impressionable_type", "message", "impressionable_id"], name: "impressionable_type_message_index"
    t.index ["user_id"], name: "index_impressions_on_user_id"
  end

  create_table "notices", force: :cascade do |t|
    t.text "details", null: false
    t.integer "reason", null: false
    t.integer "user_id"
    t.integer "given_by_id", null: false
    t.integer "noticeable_type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_notices_on_user_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.string "target_type", null: false
    t.integer "target_id", null: false
    t.string "notifiable_type", null: false
    t.integer "notifiable_id", null: false
    t.string "key", null: false
    t.string "group_type"
    t.integer "group_id"
    t.integer "group_owner_id"
    t.string "notifier_type"
    t.integer "notifier_id"
    t.text "parameters"
    t.datetime "opened_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_owner_id"], name: "index_notifications_on_group_owner_id"
    t.index ["group_type", "group_id"], name: "index_notifications_on_group_type_and_group_id"
    t.index ["notifiable_type", "notifiable_id"], name: "index_notifications_on_notifiable_type_and_notifiable_id"
    t.index ["notifier_type", "notifier_id"], name: "index_notifications_on_notifier_type_and_notifier_id"
    t.index ["target_type", "target_id"], name: "index_notifications_on_target_type_and_target_id"
  end

  create_table "photos", force: :cascade do |t|
    t.string "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "points", force: :cascade do |t|
    t.integer "user_id"
    t.integer "value"
    t.string "category"
    t.text "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_points_on_user_id"
  end

  create_table "questions", force: :cascade do |t|
    t.integer "status", default: 0
    t.string "title", default: "", null: false
    t.text "body", default: "", null: false
    t.integer "answers_count", default: 0
    t.datetime "answered_on"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.integer "cached_votes_total", default: 0
    t.integer "cached_votes_score", default: 0
    t.integer "cached_votes_up", default: 0
    t.integer "cached_votes_down", default: 0
    t.integer "impressions_count", default: 0
    t.integer "closing_notice"
    t.datetime "closed_at"
    t.integer "duplicate_id"
    t.index ["user_id"], name: "index_questions_on_user_id"
  end

  create_table "reports", force: :cascade do |t|
    t.integer "user_id"
    t.string "number"
    t.integer "reason"
    t.integer "status", default: 1
    t.string "mod_attention_details"
    t.integer "duplicate_id"
    t.integer "assigned_user_id"
    t.text "closing_notice_details"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "reportable_type"
    t.integer "reportable_id"
    t.index ["reportable_type", "reportable_id"], name: "index_reports_on_reportable_type_and_reportable_id"
  end

  create_table "scorecards", force: :cascade do |t|
    t.integer "user_id"
    t.integer "daily"
    t.integer "weekly"
    t.integer "monthly"
    t.integer "yearly"
    t.integer "lifetime"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_scorecards_on_user_id"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.string "target_type", null: false
    t.integer "target_id", null: false
    t.string "key", null: false
    t.boolean "subscribing", default: true, null: false
    t.boolean "subscribing_to_email", default: true, null: false
    t.datetime "subscribed_at"
    t.datetime "unsubscribed_at"
    t.datetime "subscribed_to_email_at"
    t.datetime "unsubscribed_to_email_at"
    t.text "optional_targets"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_subscriptions_on_key"
    t.index ["target_type", "target_id", "key"], name: "index_subscriptions_on_target_type_and_target_id_and_key", unique: true
    t.index ["target_type", "target_id"], name: "index_subscriptions_on_target_type_and_target_id"
  end

  create_table "taggings", force: :cascade do |t|
    t.integer "tag_id"
    t.string "taggable_type"
    t.integer "taggable_id"
    t.string "tagger_type"
    t.integer "tagger_id"
    t.string "context", limit: 128
    t.datetime "created_at"
    t.index ["context"], name: "index_taggings_on_context"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_id", "taggable_type", "context"], name: "taggings_taggable_context_idx"
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy"
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id"
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type"
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type"
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username", default: "", null: false
    t.string "name", default: "", null: false
    t.integer "level", default: 1, null: false
    t.integer "role", default: 1, null: false
    t.datetime "changed_role_on"
    t.integer "notices_count", default: 0
    t.boolean "banned", default: false
    t.string "avatar"
    t.string "slug"
    t.integer "questions_count", default: 0
    t.integer "answers_count", default: 0
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["slug"], name: "index_users_on_slug", unique: true
  end

  create_table "votes", force: :cascade do |t|
    t.string "votable_type"
    t.integer "votable_id"
    t.string "voter_type"
    t.integer "voter_id"
    t.boolean "vote_flag"
    t.string "vote_scope"
    t.integer "vote_weight"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["votable_id", "votable_type", "vote_scope"], name: "index_votes_on_votable_id_and_votable_type_and_vote_scope"
    t.index ["voter_id", "voter_type", "vote_scope"], name: "index_votes_on_voter_id_and_voter_type_and_vote_scope"
  end

end
