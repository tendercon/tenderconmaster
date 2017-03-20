class ContactPage < ActiveRecord::Base
  validates_presence_of :headline
  validates_presence_of :meta
  validates_presence_of :form_title
  validates_presence_of :name
  validates_presence_of :email
  validates_presence_of :message
  validates_presence_of :sent_it
end