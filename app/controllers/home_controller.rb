class HomeController < ApplicationController
  before_filter :is_logged?, except: [:index]
  layout 'home_layout', :on => [:index]

  def index

  end
end