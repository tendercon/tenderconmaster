module AddendasHelper

  def get_addenda_documents addenda_id
    documents = TenderDocument.where(:addenda_id => addenda_id)
    documents
  end

  def get_addenda_ref id
    addenda = Addenda.find(id)
    addenda.ref_no
  end

  def check_addenda_detail id
    addenda_change = AddendaChange.where(:addenda_id => id).first

    if addenda_change.present?
      addenda_change
    else
      nil
    end
  end

end