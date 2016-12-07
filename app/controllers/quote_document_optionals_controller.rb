class QuoteDocumentOptionalsController < ApplicationController

  def create_document
    tender_id = params[:tender_id]

    quote_document = QuoteDocumentOptional.new
    quote_document.tender_id = tender_id
    quote_document.document = params[:document]
    quote_document.user_id = session[:user_logged_id]


    if quote_document.save
      render :json => { :state => 'valid'}
    end


  end

  def get_documents
    @quote_document = QuoteDocument.new
    @quote_document_optional = QuoteDocumentOptional.new
    @tender_id = params[:tender_id]
    @quote_documents =  QuoteDocument.where(:tender_id => @tender_id,:user_id => session[:user_logged_id],:quote_id => nil)
    @quote_document_optionals = QuoteDocumentOptional.where(:tender_id => @tender_id,:user_id => session[:user_logged_id],:quote_id => nil)

    @data = render :partial => 'quotes/document_lists'
  end

  def delete_documents
    ids = params[:ids]
    @tender_id = params[:tender_id]
    if ids.present?
      ids.each do |id|
        if id.to_i > 0
          QuoteDocumentOptional.where(:id => id).delete_all
        end
      end
    end
    @quote_document = QuoteDocument.new
    @quote_document_optional = QuoteDocumentOptional.new
    @quote_documents =  QuoteDocument.where(:tender_id => @tender_id,:user_id => session[:user_logged_id],:quote_id => nil)
    @quote_document_optionals = QuoteDocumentOptional.where(:tender_id => @tender_id,:user_id => session[:user_logged_id],:quote_id => nil)

    @data = render :partial => 'quotes/document_lists'
  end
end