module AddendasHelper

  def get_addenda_documents addenda_id
    documents = TenderDocument.where(:addenda_id => addenda_id)
    documents
  end

  def get_addenda_ref id
    addenda = Addenda.find(id)
    addenda.ref_no
  end

end