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

ActiveRecord::Schema.define(:version => 20130814005908) do

  create_table "answers", :force => true do |t|
    t.text     "body"
    t.integer  "user_id"
    t.integer  "question_id"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.integer  "votes",       :default => 0
    t.boolean  "best_answer"
  end

  add_index "answers", ["question_id"], :name => "index_answers_on_question_id"
  add_index "answers", ["user_id"], :name => "index_answers_on_user_id"

  create_table "comments", :force => true do |t|
    t.integer  "user_id"
    t.text     "body"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.integer  "commentable_id"
    t.string   "commentable_type"
  end

  add_index "comments", ["commentable_id", "commentable_type"], :name => "index_comments_on_commentable_id_and_commentable_type"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

  create_table "question_views", :force => true do |t|
    t.integer  "question_id"
    t.integer  "user_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "question_views", ["question_id"], :name => "index_question_views_on_question_id"
  add_index "question_views", ["user_id"], :name => "index_question_views_on_user_id"

  create_table "questions", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.integer  "user_id"
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
    t.integer  "votes",                   :default => 0
    t.string   "post_type",  :limit => 1, :default => "Q"
  end

  add_index "questions", ["user_id"], :name => "index_questions_on_user_id"

  create_table "questions_tags", :force => true do |t|
    t.integer "tag_id"
    t.integer "question_id"
  end

  add_index "questions_tags", ["question_id"], :name => "index_questions_tags_on_question_id"
  add_index "questions_tags", ["tag_id"], :name => "index_questions_tags_on_tag_id"

  create_table "schools", :force => true do |t|
    t.string   "name"
    t.string   "acronym"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "schools", ["acronym"], :name => "index_schools_on_acronym", :unique => true
  add_index "schools", ["name"], :name => "index_schools_on_name", :unique => true

  create_table "tags", :force => true do |t|
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "tags", ["description"], :name => "index_tags_on_description", :unique => true

  create_table "users", :force => true do |t|
    t.string   "email",                        :null => false
    t.string   "name",                         :null => false
    t.date     "dateOfBirth",                  :null => false
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.string   "password_digest"
    t.string   "remember_token"
    t.string   "gender",          :limit => 1
    t.string   "avatar"
    t.integer  "school_id"
    t.string   "other_school"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["name"], :name => "index_users_on_name"
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"
  add_index "users", ["school_id"], :name => "index_users_on_school_id"

  create_table "votes", :force => true do |t|
    t.integer  "user_id"
    t.integer  "value"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "voteable_id"
    t.string   "voteable_type"
  end

  add_index "votes", ["user_id"], :name => "index_votes_on_user_id"
  add_index "votes", ["voteable_id", "voteable_type"], :name => "index_votes_on_voteable_id_and_voteable_type"

end
