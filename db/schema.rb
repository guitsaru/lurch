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

ActiveRecord::Schema.define(:version => 20121004052421) do

  create_table "builds", :force => true do |t|
    t.string   "sha"
    t.string   "jenkins_id"
    t.string   "status"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.integer  "project_id"
    t.string   "repo"
    t.integer  "pull_request_id"
    t.string   "pull_request_user"
    t.string   "pull_request_branch"
  end

  create_table "projects", :force => true do |t|
    t.string   "repo"
    t.string   "jenkins_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "settings", :force => true do |t|
    t.string   "key"
    t.string   "value"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
