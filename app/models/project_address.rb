class ProjectAddress < ActiveRecord::Base
  belongs_to :user
  belongs_to :project_portfolio
end