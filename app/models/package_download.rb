class PackageDownload < ActiveRecord::Base
  belongs_to :tender
  belongs_to :trade
  belongs_to :user
end