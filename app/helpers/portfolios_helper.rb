module PortfoliosHelper

  def get_category_name id

    if id.to_i > 0
      category = Category.find(id)
      category.name
    end
  end

  def get_project_avatar year,portfolio_id
    portfolio = ProjectPortfolio.where(:year => year, :id => portfolio_id).first
    if portfolio.present?
      project_avatar = ProjectAvatar.where(:project_portfolio_id => portfolio.id)
      urls = []
      if project_avatar.present?
        project_avatar.each_with_index do |a,index|
          if index == 0
            urls << request.host_with_port+"/assets/project_avatar/image/#{a.id}/original/#{a.image_file_name}"
          end

        end
      end
      urls
    end
  end

  def get_project_suburb portfolio_id
    project_address = ProjectAddress.where(:project_portfolio_id => portfolio_id).first

    if project_address.present?
      project_address.suburb
    end
  end

  def get_project_state portfolio_id
    project_address = ProjectAddress.where(:project_portfolio_id => portfolio_id).first

    if project_address.present?
      project_address.state
    end
  end

  def get_trade_name id
    if id.present? && id.to_i > 0
      trade = Trade.find(id)
      trade.name
    end
  end

  def get_parent_access user_id

    user = User.find(user_id)

    if user.present?
      if user.parent_id.present?
        user.parent_id
      else
        0
      end


    end


  end

end