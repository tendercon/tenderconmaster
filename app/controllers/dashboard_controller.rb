class DashboardController < ApplicationController

  before_filter :add_to_open_tender, :only => [:index]

  def index
    a = Time.now.end_of_day - Time.now
    puts "a =========> #{a}"
    if session[:role] == 'Admin'

    elsif session[:role] == 'Head Contractor'

    elsif session[:role] == 'Sub Contractor' || session[:role] == 'Team Member'

    end

  end



end