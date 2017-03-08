class Addenda < ActiveRecord::Base
  has_many :addenda_notifications
  validates :subject, presence: true
end