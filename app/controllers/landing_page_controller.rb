class LandingPageController < ApplicationController
  before_filter :is_logged?, except: [:index]
  skip_before_action :verify_authenticity_token

  layout 'landing_layout', :on => [:index]
  def index

  end



end