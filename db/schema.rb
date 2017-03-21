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

ActiveRecord::Schema.define(version: 20170321025855) do

  create_table "addenda_notifications", force: :cascade do |t|
    t.integer  "sc_id",      limit: 4
    t.integer  "hc_id",      limit: 4
    t.integer  "addenda_id", limit: 4
    t.integer  "tender_id",  limit: 4
    t.string   "message",    limit: 255
    t.string   "status",     limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "added_by",   limit: 255
  end

  create_table "addendas", force: :cascade do |t|
    t.integer  "tender_id",    limit: 4
    t.integer  "user_id",      limit: 4
    t.string   "subject",      limit: 255
    t.string   "ref_no",       limit: 255
    t.text     "details",      limit: 65535
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.datetime "sent"
    t.string   "addenda_type", limit: 255
    t.string   "status",       limit: 255
  end

  create_table "addresses", force: :cascade do |t|
    t.string   "state",      limit: 255
    t.string   "location",   limit: 255
    t.integer  "postcode",   limit: 4
    t.string   "suburb",     limit: 255
    t.string   "timezone",   limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "user_id",    limit: 4
  end

  create_table "avatar", force: :cascade do |t|
    t.integer  "user_id",            limit: 4
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size",    limit: 4
    t.datetime "image_updated_at"
  end

  create_table "calendar_events", force: :cascade do |t|
    t.integer  "user_id",     limit: 4
    t.string   "title",       limit: 255
    t.string   "description", limit: 255
    t.string   "category",    limit: 255
    t.datetime "event_date"
    t.string   "timezone",    limit: 255
    t.string   "repeat",      limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "categories", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.integer  "user_id",    limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "comment_documents", force: :cascade do |t|
    t.integer  "rfi_comment_id",        limit: 4
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "document_file_name",    limit: 255
    t.string   "document_content_type", limit: 255
    t.integer  "document_file_size",    limit: 4
    t.datetime "document_updated_at"
    t.string   "str_token",             limit: 255
    t.integer  "rfi_id",                limit: 4
    t.integer  "sc_id",                 limit: 4
    t.integer  "hc_id",                 limit: 4
    t.integer  "tender_id",             limit: 4
  end

  create_table "companies", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.integer  "user_id",    limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "company_avatar", force: :cascade do |t|
    t.integer  "user_id",            limit: 4
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size",    limit: 4
    t.datetime "image_updated_at"
  end

  create_table "company_pages", force: :cascade do |t|
    t.text     "headline",                       limit: 65535
    t.text     "intro",                          limit: 65535
    t.string   "team_block",                     limit: 255
    t.string   "block_heading",                  limit: 255
    t.text     "block_intro",                    limit: 65535
    t.string   "ceo_name",                       limit: 255
    t.text     "ceo_title",                      limit: 65535
    t.text     "ceo_linkedin",                   limit: 65535
    t.text     "ceo_instagram",                  limit: 65535
    t.string   "co_founder_name",                limit: 255
    t.text     "co_founder_title",               limit: 65535
    t.text     "co_founder_linkedin",            limit: 65535
    t.string   "team_name3",                     limit: 255
    t.string   "team_title3",                    limit: 255
    t.string   "team_name4",                     limit: 255
    t.string   "team_title4",                    limit: 255
    t.string   "team_name5",                     limit: 255
    t.string   "team_title5",                    limit: 255
    t.string   "team_name6",                     limit: 255
    t.string   "team_title6",                    limit: 255
    t.string   "team_name7",                     limit: 255
    t.string   "team_title7",                    limit: 255
    t.string   "team_name8",                     limit: 255
    t.string   "team_title8",                    limit: 255
    t.string   "ceo_avatar_file_name",           limit: 255
    t.string   "ceo_avatar_content_type",        limit: 255
    t.integer  "ceo_avatar_file_size",           limit: 4
    t.datetime "ceo_avatar_updated_at"
    t.string   "co_founder_avatar_file_name",    limit: 255
    t.string   "co_founder_avatar_content_type", limit: 255
    t.integer  "co_founder_avatar_file_size",    limit: 4
    t.datetime "co_founder_avatar_updated_at"
    t.string   "team3_avatar_file_name",         limit: 255
    t.string   "team3_avatar_content_type",      limit: 255
    t.integer  "team3_avatar_file_size",         limit: 4
    t.datetime "team3_avatar_updated_at"
    t.string   "team4_avatar_file_name",         limit: 255
    t.string   "team4_avatar_content_type",      limit: 255
    t.integer  "team4_avatar_file_size",         limit: 4
    t.datetime "team4_avatar_updated_at"
    t.string   "team5_avatar_file_name",         limit: 255
    t.string   "team5_avatar_content_type",      limit: 255
    t.integer  "team5_avatar_file_size",         limit: 4
    t.datetime "team5_avatar_updated_at"
    t.string   "team6_avatar_file_name",         limit: 255
    t.string   "team6_avatar_content_type",      limit: 255
    t.integer  "team6_avatar_file_size",         limit: 4
    t.datetime "team6_avatar_updated_at"
    t.string   "team7_avatar_file_name",         limit: 255
    t.string   "team7_avatar_content_type",      limit: 255
    t.integer  "team7_avatar_file_size",         limit: 4
    t.datetime "team7_avatar_updated_at"
    t.string   "team8_avatar_file_name",         limit: 255
    t.string   "team8_avatar_content_type",      limit: 255
    t.integer  "team8_avatar_file_size",         limit: 4
    t.datetime "team8_avatar_updated_at"
  end

  create_table "company_profiles", force: :cascade do |t|
    t.integer  "user_id",             limit: 4
    t.text     "about_me",            limit: 65535
    t.string   "number_of_employees", limit: 255
    t.integer  "commenced_operation", limit: 4
    t.integer  "since",               limit: 4
    t.string   "contact_number",      limit: 255
    t.string   "fax_number",          limit: 255
    t.string   "website",             limit: 255
    t.string   "linkedin",            limit: 255
    t.string   "facebook",            limit: 255
    t.string   "project_range",       limit: 255
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "acn",                 limit: 255
  end

  create_table "contact_pages", force: :cascade do |t|
    t.text     "headline",   limit: 65535
    t.text     "meta",       limit: 65535
    t.string   "form_title", limit: 255
    t.string   "name",       limit: 255
    t.text     "email",      limit: 65535
    t.string   "message",    limit: 255
    t.text     "sent_it",    limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   limit: 4,     default: 0, null: false
    t.integer  "attempts",   limit: 4,     default: 0, null: false
    t.text     "handler",    limit: 65535,             null: false
    t.text     "last_error", limit: 65535
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by",  limit: 255
    t.string   "queue",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "document_packages", force: :cascade do |t|
    t.integer  "tender_id",  limit: 4
    t.integer  "user_id",    limit: 4
    t.text     "path",       limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.text     "url",        limit: 65535
  end

  create_table "email_notifications", force: :cascade do |t|
    t.integer  "user_id",     limit: 4
    t.string   "description", limit: 255
    t.string   "status",      limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "feature_pages", force: :cascade do |t|
    t.string   "page_type",                   limit: 255
    t.text     "headline",                    limit: 65535
    t.text     "tagline",                     limit: 65535
    t.string   "feature_block_1",             limit: 255
    t.string   "feature_block_2",             limit: 255
    t.string   "feature_block_3",             limit: 255
    t.string   "feature_block_4",             limit: 255
    t.text     "feature_title",               limit: 65535
    t.text     "feature_desc",                limit: 65535
    t.text     "feature_title2",              limit: 65535
    t.text     "feature_desc2",               limit: 65535
    t.text     "feature_title3",              limit: 65535
    t.text     "feature_desc3",               limit: 65535
    t.text     "feature_title4",              limit: 65535
    t.text     "feature_desc4",               limit: 65535
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.string   "figure_holder_file_name",     limit: 255
    t.string   "figure_holder_content_type",  limit: 255
    t.integer  "figure_holder_file_size",     limit: 4
    t.datetime "figure_holder_updated_at"
    t.string   "figure_holder2_file_name",    limit: 255
    t.string   "figure_holder2_content_type", limit: 255
    t.integer  "figure_holder2_file_size",    limit: 4
    t.datetime "figure_holder2_updated_at"
    t.string   "figure_holder3_file_name",    limit: 255
    t.string   "figure_holder3_content_type", limit: 255
    t.integer  "figure_holder3_file_size",    limit: 4
    t.datetime "figure_holder3_updated_at"
    t.string   "figure_holder4_file_name",    limit: 255
    t.string   "figure_holder4_content_type", limit: 255
    t.integer  "figure_holder4_file_size",    limit: 4
    t.datetime "figure_holder4_updated_at"
  end

  create_table "google_calendar_events", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.text     "token",      limit: 65535
    t.string   "email",      limit: 255
    t.string   "summary",    limit: 255
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.datetime "start_date"
    t.datetime "end_date"
  end

  create_table "hc_invites", force: :cascade do |t|
    t.integer  "hc_id",      limit: 4
    t.integer  "trade_id",   limit: 4
    t.integer  "user_id",    limit: 4
    t.string   "email",      limit: 255
    t.string   "company",    limit: 255
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "status",     limit: 255
  end

  create_table "header_navs", force: :cascade do |t|
    t.string   "page_type",         limit: 255
    t.string   "home",              limit: 255
    t.string   "feature",           limit: 255
    t.string   "pricing",           limit: 255
    t.string   "company",           limit: 255
    t.string   "login",             limit: 255
    t.string   "register",          limit: 255
    t.boolean  "hide_pricing",                  default: true
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.string   "logo_file_name",    limit: 255
    t.string   "logo_content_type", limit: 255
    t.integer  "logo_file_size",    limit: 4
    t.datetime "logo_updated_at"
    t.string   "user_type",         limit: 255
  end

  create_table "invited_tender_notifications", force: :cascade do |t|
    t.integer  "sc_id",            limit: 4
    t.integer  "hc_id",            limit: 4
    t.integer  "tender_invite_id", limit: 4
    t.integer  "tender_id",        limit: 4
    t.string   "message",          limit: 255
    t.string   "status",           limit: 255
    t.string   "added_by",         limit: 255
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "trade_id",         limit: 4
  end

  create_table "message_chats", force: :cascade do |t|
    t.integer  "tender_id",  limit: 4
    t.integer  "trade_id",   limit: 4
    t.integer  "to_id",      limit: 4
    t.integer  "from_id",    limit: 4
    t.text     "message",    limit: 65535
    t.string   "group_name", limit: 255
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "status",     limit: 255
  end

  create_table "messages", force: :cascade do |t|
    t.integer  "tender_id",  limit: 4
    t.integer  "trade_id",   limit: 4
    t.integer  "sc_id",      limit: 4
    t.integer  "hc_id",      limit: 4
    t.string   "channel",    limit: 255
    t.text     "message",    limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "group_name", limit: 255
    t.integer  "from",       limit: 4
    t.integer  "to",         limit: 4
  end

  create_table "notifications", force: :cascade do |t|
    t.integer  "user_id",     limit: 4
    t.string   "description", limit: 255
    t.string   "status",      limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "open_tender_trades", force: :cascade do |t|
    t.integer  "tender_id",  limit: 4
    t.integer  "user_id",    limit: 4
    t.integer  "trade_id",   limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "open_tenders", force: :cascade do |t|
    t.integer  "tender_id",  limit: 4
    t.integer  "user_id",    limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "package_downloads", force: :cascade do |t|
    t.integer  "tender_id",  limit: 4
    t.integer  "trade_id",   limit: 4
    t.integer  "user_id",    limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "packages", force: :cascade do |t|
    t.integer  "tender_id",  limit: 4
    t.string   "code",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "positions", force: :cascade do |t|
    t.string   "title",      limit: 255
    t.integer  "user_id",    limit: 4
    t.integer  "parent_id",  limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "status",     limit: 4
  end

  create_table "pricing_pages", force: :cascade do |t|
    t.text   "headline",                 limit: 65535
    t.text   "intro",                    limit: 65535
    t.string "pricing_block",            limit: 255
    t.string "scrollto_pricing_block",   limit: 255
    t.text   "scrollto_faqs_block",      limit: 65535
    t.string "block_heading",            limit: 255
    t.text   "item_heading",             limit: 65535
    t.text   "item_intro",               limit: 65535
    t.text   "currency",                 limit: 65535
    t.string "number",                   limit: 255
    t.text   "unit",                     limit: 65535
    t.text   "sign_up_now",              limit: 65535
    t.text   "tender_limit",             limit: 65535
    t.text   "item_heading2",            limit: 65535
    t.text   "item_intro2",              limit: 65535
    t.text   "currency2",                limit: 65535
    t.string "number2",                  limit: 255
    t.text   "unit2",                    limit: 65535
    t.text   "sign_up_now2",             limit: 65535
    t.text   "tender_limit2",            limit: 65535
    t.text   "item_heading3",            limit: 65535
    t.text   "item_intro3",              limit: 65535
    t.text   "currency3",                limit: 65535
    t.string "number3",                  limit: 255
    t.text   "unit3",                    limit: 65535
    t.text   "sign_up_now3",             limit: 65535
    t.text   "tender_limit3",            limit: 65535
    t.text   "frequently_block_heading", limit: 65535
    t.text   "faq1",                     limit: 65535
    t.text   "faq2",                     limit: 65535
    t.text   "faq3",                     limit: 65535
    t.text   "faq4",                     limit: 65535
    t.text   "faq5",                     limit: 65535
    t.text   "faq6",                     limit: 65535
    t.text   "faq7",                     limit: 65535
    t.text   "faq8",                     limit: 65535
    t.text   "faq1_desc",                limit: 65535
    t.text   "faq2_desc",                limit: 65535
    t.text   "faq3_desc",                limit: 65535
    t.text   "faq4_desc",                limit: 65535
    t.text   "faq5_desc",                limit: 65535
    t.text   "faq6_desc",                limit: 65535
    t.text   "faq7_desc",                limit: 65535
    t.text   "faq8_desc",                limit: 65535
    t.text   "tender_limit1",            limit: 65535
    t.text   "tender_limit1_1",          limit: 65535
    t.text   "tender_limit1_2",          limit: 65535
    t.text   "tender_limit1_3",          limit: 65535
    t.text   "tender_limit1_4",          limit: 65535
    t.text   "tender_limit1_5",          limit: 65535
    t.text   "tender_limit1_6",          limit: 65535
    t.text   "tender_limit1_7",          limit: 65535
    t.text   "tender_limit1_8",          limit: 65535
    t.text   "tender_limit1_9",          limit: 65535
    t.text   "tender_limit1_0",          limit: 65535
    t.text   "tender_limit1_11",         limit: 65535
    t.text   "tender_limit1_12",         limit: 65535
    t.text   "tender_limit1_13",         limit: 65535
    t.text   "tender_limit2_1",          limit: 65535
    t.text   "tender_limit2_2",          limit: 65535
    t.text   "tender_limit2_3",          limit: 65535
    t.text   "tender_limit2_4",          limit: 65535
    t.text   "tender_limit2_5",          limit: 65535
    t.text   "tender_limit2_6",          limit: 65535
    t.text   "tender_limit2_7",          limit: 65535
    t.text   "tender_limit2_8",          limit: 65535
    t.text   "tender_limit2_9",          limit: 65535
    t.text   "tender_limit2_0",          limit: 65535
    t.text   "tender_limit2_11",         limit: 65535
    t.text   "tender_limit2_12",         limit: 65535
    t.text   "tender_limit2_13",         limit: 65535
    t.text   "tender_limit2_14",         limit: 65535
    t.text   "tender_limit3_1",          limit: 65535
    t.text   "tender_limit3_2",          limit: 65535
    t.text   "tender_limit3_3",          limit: 65535
    t.text   "tender_limit3_4",          limit: 65535
    t.text   "tender_limit3_5",          limit: 65535
    t.text   "tender_limit3_6",          limit: 65535
    t.text   "tender_limit3_7",          limit: 65535
    t.text   "tender_limit3_8",          limit: 65535
    t.text   "tender_limit3_9",          limit: 65535
    t.text   "tender_limit3_0",          limit: 65535
    t.text   "tender_limit3_11",         limit: 65535
    t.text   "tender_limit3_12",         limit: 65535
    t.text   "tender_limit3_13",         limit: 65535
    t.text   "tender_limit3_14",         limit: 65535
  end

  create_table "primary_trades", force: :cascade do |t|
    t.integer  "trade_id",   limit: 4
    t.integer  "user_id",    limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "project_addresses", force: :cascade do |t|
    t.string   "state",                limit: 255
    t.string   "location",             limit: 255
    t.integer  "postcode",             limit: 4
    t.string   "suburb",               limit: 255
    t.string   "timezone",             limit: 255
    t.integer  "project_portfolio_id", limit: 4
    t.integer  "user_id",              limit: 4
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  create_table "project_avatars", force: :cascade do |t|
    t.integer  "user_id",              limit: 4
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.string   "image_file_name",      limit: 255
    t.string   "image_content_type",   limit: 255
    t.integer  "image_file_size",      limit: 4
    t.datetime "image_updated_at"
    t.integer  "project_portfolio_id", limit: 4
  end

  create_table "project_portfolios", force: :cascade do |t|
    t.integer  "user_id",       limit: 4
    t.integer  "parent_id",     limit: 4
    t.string   "client",        limit: 255
    t.integer  "year",          limit: 4
    t.text     "about_me",      limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "category_id",   limit: 4
    t.string   "project_range", limit: 255
    t.string   "company",       limit: 255
  end

  create_table "project_trades", force: :cascade do |t|
    t.integer  "trade_id",             limit: 4
    t.integer  "user_id",              limit: 4
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "project_portfolio_id", limit: 4
  end

  create_table "quote_document_optionals", force: :cascade do |t|
    t.integer  "quote_id",              limit: 4
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "document_file_name",    limit: 255
    t.string   "document_content_type", limit: 255
    t.integer  "document_file_size",    limit: 4
    t.datetime "document_updated_at"
    t.integer  "tender_id",             limit: 4
    t.integer  "user_id",               limit: 4
  end

  create_table "quote_documents", force: :cascade do |t|
    t.integer  "quote_id",              limit: 4
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "document_file_name",    limit: 255
    t.string   "document_content_type", limit: 255
    t.integer  "document_file_size",    limit: 4
    t.datetime "document_updated_at"
    t.integer  "tender_id",             limit: 4
    t.integer  "user_id",               limit: 4
  end

  create_table "quote_notifications", force: :cascade do |t|
    t.integer  "sc_id",      limit: 4
    t.integer  "hc_id",      limit: 4
    t.integer  "quote_id",   limit: 4
    t.string   "message",    limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "tender_id",  limit: 4
    t.integer  "seen",       limit: 4
  end

  create_table "quotes", force: :cascade do |t|
    t.integer  "user_id",     limit: 4
    t.string   "ref_no",      limit: 255
    t.string   "to",          limit: 255
    t.string   "attention",   limit: 255
    t.datetime "quote_date"
    t.string   "description", limit: 255
    t.integer  "trade_id",    limit: 4
    t.integer  "tender_id",   limit: 4
    t.float    "price",       limit: 24
    t.string   "status",      limit: 255
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.string   "title",       limit: 255
    t.string   "version",     limit: 255
    t.boolean  "seen",                    default: false
  end

  create_table "request_upgrades", force: :cascade do |t|
    t.string   "plan",       limit: 255
    t.integer  "user_id",    limit: 4
    t.integer  "plan_id",    limit: 4
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.string   "status",     limit: 255, default: "pending"
  end

  create_table "requested_tender_notifications", force: :cascade do |t|
    t.integer  "sc_id",                   limit: 4
    t.integer  "hc_id",                   limit: 4
    t.integer  "tender_request_quote_id", limit: 4
    t.integer  "tender_id",               limit: 4
    t.string   "message",                 limit: 255
    t.string   "status",                  limit: 255
    t.string   "added_by",                limit: 255
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  create_table "rfi_comments", force: :cascade do |t|
    t.integer  "rfi_id",        limit: 4
    t.string   "comment",       limit: 255
    t.integer  "sc_id",         limit: 4
    t.integer  "hc_id",         limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "date_resolved"
    t.integer  "sender",        limit: 4
  end

  create_table "rfi_documents", force: :cascade do |t|
    t.integer  "user_id",               limit: 4
    t.integer  "rfi_id",                limit: 4
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "document_file_name",    limit: 255
    t.string   "document_content_type", limit: 255
    t.integer  "document_file_size",    limit: 4
    t.datetime "document_updated_at"
    t.integer  "tender_id",             limit: 4
    t.string   "rfi_ref_no",            limit: 255
  end

  create_table "rfi_notifications", force: :cascade do |t|
    t.integer  "sc_id",      limit: 4
    t.integer  "hc_id",      limit: 4
    t.integer  "rfi_id",     limit: 4
    t.integer  "tender_id",  limit: 4
    t.string   "message",    limit: 255
    t.string   "status",     limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "added_by",   limit: 255
  end

  create_table "rfis", force: :cascade do |t|
    t.integer  "user_id",       limit: 4
    t.string   "ref_no",        limit: 255
    t.string   "to",            limit: 255
    t.string   "attention",     limit: 255
    t.datetime "rfi_date"
    t.datetime "response_date"
    t.string   "heading",       limit: 255
    t.string   "description",   limit: 255
    t.integer  "trade_id",      limit: 4
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "tender_id",     limit: 4
    t.integer  "hc_id",         limit: 4
    t.string   "status",        limit: 255
    t.datetime "date_resolved"
    t.string   "seen",          limit: 255
    t.integer  "request",       limit: 4
  end

  create_table "roles", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.integer  "user_id",    limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "sc_invite_notifications", force: :cascade do |t|
    t.integer  "tender_id",   limit: 4
    t.integer  "user_id",     limit: 4
    t.string   "message",     limit: 255
    t.string   "user_status", limit: 255
    t.integer  "seen",        limit: 4
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "secondary_trades", force: :cascade do |t|
    t.integer  "trade_id",   limit: 4
    t.integer  "user_id",    limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id", limit: 255,   null: false
    t.text     "data",       limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", unique: true, using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "shared_rfis", force: :cascade do |t|
    t.integer  "rfi_id",     limit: 4
    t.integer  "trade_id",   limit: 4
    t.integer  "user_id",    limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "shared",     limit: 255
    t.string   "status",     limit: 255
  end

  create_table "sites", force: :cascade do |t|
    t.string   "page",                            limit: 255
    t.string   "title",                           limit: 255
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.string   "page_type",                       limit: 255
    t.text     "header_headline",                 limit: 65535
    t.text     "header_tagline",                  limit: 65535
    t.text     "section_title",                   limit: 65535
    t.text     "section_intro",                   limit: 65535
    t.text     "item_title",                      limit: 65535
    t.text     "item_desc",                       limit: 65535
    t.text     "item_title1",                     limit: 65535
    t.text     "item_desc1",                      limit: 65535
    t.text     "item_title2",                     limit: 65535
    t.text     "item_desc2",                      limit: 65535
    t.string   "section_image1_file_name",        limit: 255
    t.string   "section_image1_content_type",     limit: 255
    t.integer  "section_image1_file_size",        limit: 4
    t.datetime "section_image1_updated_at"
    t.string   "section_image2_file_name",        limit: 255
    t.string   "section_image2_content_type",     limit: 255
    t.integer  "section_image2_file_size",        limit: 4
    t.datetime "section_image2_updated_at"
    t.string   "section_image3_file_name",        limit: 255
    t.string   "section_image3_content_type",     limit: 255
    t.integer  "section_image3_file_size",        limit: 4
    t.datetime "section_image3_updated_at"
    t.string   "item_image1_file_name",           limit: 255
    t.string   "item_image1_content_type",        limit: 255
    t.integer  "item_image1_file_size",           limit: 4
    t.datetime "item_image1_updated_at"
    t.string   "item_image2_file_name",           limit: 255
    t.string   "item_image2_content_type",        limit: 255
    t.integer  "item_image2_file_size",           limit: 4
    t.datetime "item_image2_updated_at"
    t.string   "item_image3_file_name",           limit: 255
    t.string   "item_image3_content_type",        limit: 255
    t.integer  "item_image3_file_size",           limit: 4
    t.datetime "item_image3_updated_at"
    t.string   "key_feature_image1_file_name",    limit: 255
    t.string   "key_feature_image1_content_type", limit: 255
    t.integer  "key_feature_image1_file_size",    limit: 4
    t.datetime "key_feature_image1_updated_at"
    t.string   "section_title_trusted_by_smart",  limit: 255
    t.text     "section_intro_trusted_by_smart",  limit: 65535
    t.text     "quote_intro",                     limit: 65535
    t.string   "quote_name",                      limit: 255
    t.string   "quote_title",                     limit: 255
    t.text     "quote_intro2",                    limit: 65535
    t.string   "quote_name2",                     limit: 255
    t.string   "quote_title2",                    limit: 255
    t.string   "quote_profile_file_name",         limit: 255
    t.string   "quote_profile_content_type",      limit: 255
    t.integer  "quote_profile_file_size",         limit: 4
    t.datetime "quote_profile_updated_at"
    t.string   "quote_profile2_file_name",        limit: 255
    t.string   "quote_profile2_content_type",     limit: 255
    t.integer  "quote_profile2_file_size",        limit: 4
    t.datetime "quote_profile2_updated_at"
  end

  create_table "tender_approved_trades", force: :cascade do |t|
    t.integer  "tender_id",               limit: 4
    t.integer  "sc_id",                   limit: 4
    t.integer  "hc_id",                   limit: 4
    t.integer  "trade_id",                limit: 4
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "status",                  limit: 255
    t.integer  "tender_request_quote_id", limit: 4
  end

  create_table "tender_documents", force: :cascade do |t|
    t.integer  "user_id",               limit: 4
    t.integer  "tender_id",             limit: 4
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "document_file_name",    limit: 255
    t.string   "document_content_type", limit: 255
    t.integer  "document_file_size",    limit: 4
    t.datetime "document_updated_at"
    t.string   "directory",             limit: 255
    t.string   "revision",              limit: 255
    t.text     "document_path",         limit: 65535
    t.string   "status",                limit: 255
    t.string   "action_type",           limit: 255
    t.integer  "addenda_id",            limit: 4
    t.string   "package_type",          limit: 255
  end

  create_table "tender_invites", force: :cascade do |t|
    t.integer  "trade_id",               limit: 4
    t.integer  "tender_id",              limit: 4
    t.string   "name",                   limit: 255
    t.string   "email",                  limit: 255
    t.string   "status",                 limit: 255
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
    t.integer  "user_id",                limit: 4
    t.datetime "email_sent"
    t.boolean  "user_seen",                          default: false
    t.datetime "tender_open_date"
    t.datetime "tender_acceptance_date"
    t.datetime "tender_declined_date"
    t.string   "company",                limit: 255
  end

  create_table "tender_packages", force: :cascade do |t|
    t.integer  "tender_id",          limit: 4
    t.integer  "trade_id",           limit: 4
    t.integer  "category_id",        limit: 4
    t.integer  "tender_document_id", limit: 4
    t.string   "status",             limit: 255
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  create_table "tender_quotes", force: :cascade do |t|
    t.string   "quote_date",        limit: 255
    t.string   "quote_description", limit: 255
    t.integer  "tender_id",         limit: 4
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.string   "previous_date",     limit: 255
  end

  create_table "tender_request_notifications", force: :cascade do |t|
    t.integer  "sc_id",                   limit: 4
    t.integer  "hc_id",                   limit: 4
    t.integer  "tender_request_quote_id", limit: 4
    t.integer  "tender_id",               limit: 4
    t.string   "message",                 limit: 255
    t.string   "status",                  limit: 255
    t.string   "added_by",                limit: 255
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  create_table "tender_request_quotes", force: :cascade do |t|
    t.integer  "tender_id",     limit: 4
    t.integer  "sc_id",         limit: 4
    t.integer  "hc_id",         limit: 4
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.datetime "request_date"
    t.datetime "approved_date"
    t.datetime "declined_date"
    t.integer  "trade_id",      limit: 4
    t.string   "status",        limit: 255
    t.string   "tender_type",   limit: 255
  end

  create_table "tender_request_trades", force: :cascade do |t|
    t.integer  "tender_request_quote_id", limit: 4
    t.integer  "trade_id",                limit: 4
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  create_table "tender_sites", force: :cascade do |t|
    t.string   "site_date",        limit: 255
    t.string   "site_description", limit: 255
    t.integer  "tender_id",        limit: 4
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.string   "previous_date",    limit: 255
    t.integer  "user_id",          limit: 4
  end

  create_table "tender_trades", force: :cascade do |t|
    t.integer  "trade_id",   limit: 4
    t.integer  "tender_id",  limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "tender_values", force: :cascade do |t|
    t.string   "range",      limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "tendercon_code", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "tenders", force: :cascade do |t|
    t.string   "title",           limit: 255
    t.text     "description",     limit: 65535
    t.string   "address",         limit: 255
    t.string   "state",           limit: 255
    t.integer  "postcode",        limit: 4
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.string   "suburb",          limit: 255
    t.string   "address_terms",   limit: 255
    t.string   "client",          limit: 255
    t.integer  "category_id",     limit: 4
    t.string   "architect",       limit: 255
    t.integer  "tender_value_id", limit: 4
    t.string   "status",          limit: 255
    t.integer  "user_id",         limit: 4
    t.string   "tendercon_id",    limit: 255
    t.string   "hide_document",   limit: 255
    t.boolean  "publish",                       default: false
    t.string   "status_updated",  limit: 255
  end

  create_table "time_availabilities", force: :cascade do |t|
    t.string   "availability", limit: 255
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "trade_categories", force: :cascade do |t|
    t.string   "title",      limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "trades", force: :cascade do |t|
    t.string   "name",              limit: 255
    t.string   "trade_category_id", limit: 255
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "status",            limit: 4
    t.integer  "user_id",           limit: 4
  end

  create_table "unzip_files", force: :cascade do |t|
    t.text     "path",               limit: 65535
    t.integer  "user_id",            limit: 4
    t.string   "extension",          limit: 255
    t.string   "filename",           limit: 255
    t.string   "directory",          limit: 255
    t.integer  "file_size",          limit: 4
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.integer  "tender_document_id", limit: 4
    t.string   "revision",           limit: 255
    t.integer  "tender_id",          limit: 4
  end

  create_table "user_facebooks", force: :cascade do |t|
    t.string   "provider",         limit: 255
    t.string   "uid",              limit: 255
    t.string   "name",             limit: 255
    t.string   "email",            limit: 255
    t.string   "oauth_token",      limit: 255
    t.string   "oauth_expires_at", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id",          limit: 4
  end

  create_table "user_infos", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.text     "about_me",   limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "linkedin",   limit: 255
  end

  create_table "user_linkedins", force: :cascade do |t|
    t.string   "provider",         limit: 255
    t.string   "uid",              limit: 255
    t.string   "name",             limit: 255
    t.string   "email",            limit: 255
    t.string   "oauth_token",      limit: 255
    t.string   "oauth_expires_at", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_plans", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.string   "plan",       limit: 255
    t.integer  "plan_id",    limit: 4
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.decimal  "amount",                 precision: 5, scale: 2
    t.string   "role_type",  limit: 255
  end

  create_table "user_subscriptions", force: :cascade do |t|
    t.integer  "user_id",                  limit: 4
    t.boolean  "subscribed"
    t.string   "stripe_id",                limit: 255
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
    t.date     "expiry_date"
    t.boolean  "notify1",                              default: false
    t.boolean  "notify2",                              default: false
    t.boolean  "notify3",                              default: false
    t.boolean  "notify4",                              default: false
    t.boolean  "lightbox1",                            default: false
    t.boolean  "lightbox2",                            default: false
    t.boolean  "lightbox3",                            default: false
    t.boolean  "lightbox4",                            default: false
    t.boolean  "lightbox5",                            default: false
    t.string   "action_type",              limit: 255
    t.string   "card_number",              limit: 255
    t.string   "customer_subscription_id", limit: 255
  end

  create_table "user_tenders", force: :cascade do |t|
    t.integer  "tender_id",  limit: 4
    t.integer  "user_id",    limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "name",               limit: 255
    t.string   "email",              limit: 255
    t.string   "password",           limit: 255
    t.string   "confirmed_password", limit: 255
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.string   "company",            limit: 255
    t.string   "role",               limit: 255
    t.integer  "parent_id",          limit: 4
    t.boolean  "verified",                       default: false
    t.string   "unique_key",         limit: 255
    t.integer  "logged_count",       limit: 4
    t.integer  "error_logs",         limit: 4
    t.string   "abn",                limit: 255
    t.string   "tendercon_id",       limit: 255
    t.integer  "position",           limit: 4
    t.string   "first_name",         limit: 255
    t.string   "last_name",          limit: 255
    t.string   "trade_name",         limit: 255
    t.string   "tendercon_key",      limit: 255
    t.string   "status",             limit: 255
    t.boolean  "div_status",                     default: false
    t.string   "mobile_number",      limit: 255
    t.string   "role_type",          limit: 255
    t.boolean  "email_acceptance",               default: false
    t.boolean  "invited",                        default: true
    t.boolean  "registered",                     default: false
    t.boolean  "shown",                          default: false
    t.string   "logged_status",      limit: 255
  end

end
