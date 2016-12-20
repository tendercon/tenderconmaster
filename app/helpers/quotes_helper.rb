module QuotesHelper

  def get_ref_no id
    quote = Quote.find(id)

    if quote.present?
      quote.ref_no
    else
      nil
    end
  end

  def get_id ref_no
    quote = Quote.where(:ref_no => ref_no).first

    if quote.present?
      quote.id
    else
      nil
    end
  end

  def get_tender_id ref_no
    quote = Quote.where(:ref_no => ref_no).first
    if quote.present?
      quote.tender_id
    else
      nil
    end
  end



  def get_version ref_no
    quote = Quote.where(:ref_no => ref_no).first

    if quote.present?
      quote.version
    else
      nil
    end
  end

  def get_title ref_no
    quote = Quote.where(:ref_no => ref_no).first

    if quote.present?
      quote.title
    else
      nil
    end
  end

  def get_trade_counts ref_no
    quote = Quote.where(:ref_no => ref_no).count()

    if quote.present?
      quote
    else
      nil
    end
  end

  def get_trades ref_no
    quotes = Quote.where(:ref_no => ref_no)

    if quotes.present?
      quotes
    else
      nil
    end
  end

  def get_status ref_no
    quote = Quote.where(:ref_no => ref_no).first

    if quote.present?
      quote.status
    else
      nil
    end
  end

  def get_price ref_no
    quote = Quote.where(:ref_no => ref_no).first

    if quote.present?
      quote.price
    else
      nil
    end
  end

  def get_received ref_no
    quote = Quote.where(:ref_no =>ref_no).first

    if quote.present?
      notif = QuoteNotification.where(:quote_id => quote.id).first

      if notif.present?
        notif.updated_at.strftime("%d.%m.%Y")
      end

    end
  end

  def get_created ref_no
    quote = Quote.where(:ref_no =>ref_no).first

    if quote.present?
      quote.created_at.strftime("%d.%m.%Y")
    else
      nil
    end
  end

  def get_seen_status ref_no
    quote = Quote.where(:ref_no =>ref_no).first

    if quote.present?
      notif = QuoteNotification.where(:quote_id => quote.id).first

      if notif.present?
        notif.seen
      end
    end
  end

  def get_quote_user_company ref_no
    quote = Quote.where(:ref_no =>ref_no).first

    if quote.present?
      user = User.where(:id => quote.user_id).first

      if user.present?
        user.company
      end
    end
  end

  def get_quote_count tender_id
    Quote.where(:tender_id => tender_id).count()
  end
end