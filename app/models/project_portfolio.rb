class ProjectPortfolio < ActiveRecord::Base
  belongs_to :user
  has_one :project_address
  has_many :project_trades

  validates :client, presence: true, :on => :update
end