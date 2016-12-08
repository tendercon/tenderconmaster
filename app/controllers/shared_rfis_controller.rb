class SharedRfisController < ApplicationController
  skip_before_action :verify_authenticity_token
  def shared_by_trade
    rfi_id = params[:rfi_id]
    trade_id = params[:trade_id]
    user_ids = params[:user_ids]
    trades = params[:trades]
    rfi_ids = params[:ids]
    manual_rfis = params[:manual_rfis]


    if user_ids.present? && !manual_rfis.present?
      user_ids.each_with_index do |a,index|
        shared_rfi = SharedRfi.new
        shared_rfi.trade_id = trades[index]
        shared_rfi.user_id = a
        shared_rfi.rfi_id = rfi_id
        shared_rfi.status = 'manual'
        shared_rfi.save
      end
      @shared_rfis = SharedRfi.where(:rfi_id => rfi_id,:status => 'manual')
      @shared_trades = []
      if @shared_rfis.present?
        @shared_rfis.each do |a|
          @shared_trades << a.rfi_id
        end
      end

      @data = render :partial => 'shared_rfis/manual'
    elsif manual_rfis.present?

      manual_rfis.each do |r|
        if r != 'on'
          rfi = Rfi.find(r)
          user_ids.each_with_index do |a,index|
            shared =  SharedRfi.where(:rfi_id => r,:status => 'manual',:trade_id => trades[index]).first

            if !shared.present?
              shared_rfi = SharedRfi.new
              shared_rfi.trade_id = trades[index]
              shared_rfi.user_id = a
              shared_rfi.rfi_id = r
              shared_rfi.status = 'manual'
              shared_rfi.save
            end
          end

        end
      end

      @shared_rfis = SharedRfi.where(:rfi_id => manual_rfis,:status => 'manual')
      @shared_trades = []
      @trade = Hash.new
      if @shared_rfis.present?
        @shared_rfis.each do |a|
          @shared_trades << a.rfi_id
          @trade[a.rfi_id] = a.trade_id
        end
      end
      @data = render :partial => 'shared_rfis/shared_register'

    elsif rfi_ids.present?

      rfi_ids.each do |r|
        if r != 'on'
          rfi = Rfi.find(r)
          primary_trades = PrimaryTrade.where(:trade_id => rfi.trade_id)
          if primary_trades.present?
            primary_trades.each do |t|
              shared = SharedRfi.where(:trade_id => t.trade_id,:user_id => t.user_id,:rfi_id => r).first

              if !shared.present?
                shared_rfi = SharedRfi.new
                shared_rfi.trade_id = t.trade_id
                shared_rfi.user_id = t.user_id
                shared_rfi.rfi_id = r
                shared_rfi.save
              end
            end
          end
        end
      end

      @shared_rfis = SharedRfi.where(:rfi_id => rfi_ids,:status => nil,:shared => nil)
      @shared_trades = []
      @trade = Hash.new
      if @shared_rfis.present?
        @shared_rfis.each do |a|
          @shared_trades << a.rfi_id
          @trade[a.rfi_id] = a.trade_id
        end
      end
      @data = render :partial => 'shared_rfis/shared_register'
    else
      primary_trades = PrimaryTrade.where(:trade_id => trade_id)
      if primary_trades.present?
        primary_trades.each do |t|
          shared_rfi = SharedRfi.new
          shared_rfi.trade_id = t.trade_id
          shared_rfi.user_id = t.user_id
          shared_rfi.rfi_id = rfi_id
          shared_rfi.save
        end
      end
      @shared_rfis = SharedRfi.where(:rfi_id => rfi_id,:status => nil,:shared => nil)
      @trades = []
      if @shared_rfis.present?
        @shared_rfis.each do |a|
          @trades << a.trade_id
        end
      end
      @data = render :partial => 'shared_rfis/manual'
    end
  end

  def shared_by_approved_sub
    rfi_id = params[:rfi_id]
    trade_id = params[:trade_id]
    subs = params[:subs]
    tender_approved_trades = TenderApprovedTrade.where(:hc_id => session[:user_logged_id])

    if subs.present?
      subs.each do |r|
        if r != 'on'
          rfi = Rfi.find(r)
          if tender_approved_trades.present?
            tender_approved_trades.each do |a|
              if a.trade_id == rfi.trade_id
                shared = SharedRfi.where(:trade_id =>rfi.trade_id,:user_id => a.sc_id,:rfi_id => r,:shared => 'shared').first

                if !shared.present?
                  shared_rfi = SharedRfi.new
                  shared_rfi.trade_id = a.trade_id
                  shared_rfi.user_id = a.sc_id
                  shared_rfi.rfi_id = r
                  shared_rfi.shared = 'shared'
                  shared_rfi.save
                end
              end
            end
          end
        end
      end

      render :json => {:state => 'valid'}
    else
        if tender_approved_trades.present?
          tender_approved_trades.each do |a|
            shared_rfi = SharedRfi.new
            shared_rfi.trade_id = trade_id
            shared_rfi.user_id = a.sc_id
            shared_rfi.rfi_id = rfi_id
            shared_rfi.shared = 'shared'
            shared_rfi.save
          end
        end

        @shared_rfis = SharedRfi.where(:rfi_id => rfi_id,:status => nil,:shared => 'shared')
        @trades = []
        if @shared_rfis.present?
          @shared_rfis.each do |a|
            @trades << a.trade_id
          end
        end
        @data = render :partial => 'shared_rfis/manual'
      end


    end


    private

    def share_params
      params.require(:shared_rfi).permit(:id,:user_id,:trade_id,:rfi_id)
    end

  end