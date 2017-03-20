class LandingPageController < ApplicationController

  skip_before_action :verify_authenticity_token

  layout 'test_layout', :on => [:index]
  def index

  end



end