class HomeController < ApplicationController
  before_filter :is_logged?, except: [:index]
  layout 'home_layout', :on => [:index]
  skip_before_action :verify_authenticity_token
  def index

  end
end