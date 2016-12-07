module RfisHelper

  def get_user_company trade_id

    primary = PrimaryTrade.where(:trade_id => trade_id)

    if primary.present?
      primary
    else
      nil
    end
  end

  def get_company user_id

    begin
      user = User.find(user_id)

      if user.present?
        user.company
      else
        nil
      end
    rescue
      nil
    end


  end

  def get_shared_manually rfi_id

    shared_rfis = SharedRfi.where(:rfi_id => rfi_id,:status => 'manual')

    if shared_rfis.present?
      shared_rfis
    else
      nil
    end
  end

  def get_tender_id rfi_id

    begin
      rfi = Rfi.find(rfi_id)

      if rfi.present?
        rfi.tender_id
      end
    rescue
      nil
    end
  end

  def get_rfi_ref_no rfi_id
    begin
      rfi = Rfi.find(rfi_id)

      if rfi.present?
        rfi.ref_no
      end
    rescue

    end

  end

  def get_rfi_heading rfi_id
    rfi = Rfi.find(rfi_id)

    if rfi.present?
      rfi.heading
    end

  end

  def get_rfi_status rfi_id
    rfi = Rfi.find(rfi_id)

    if rfi.present?
      rfi.status
    end
  end

  def get_rfi_trade_id rfi_id
    rfi = Rfi.find(rfi_id)

    if rfi.present?
      rfi.id
    end
  end

  def get_rfi_trade_name rfi_id
    rfi = Rfi.find(rfi_id)

    if rfi.present?
      trade = Trade.find(rfi.trade_id)

      if trade.present?
        trade.name
      end
    end
  end

  def rfi_is_shared? rfi_id
   shared = SharedRfi.where(:rfi_id => rfi_id).first

   if shared.present?
     true
   else
     false
   end
  end


end