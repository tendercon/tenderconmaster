class QuoteDocumentsController < ApplicationController

  def create_document
    tender_id = params[:tender_id]

    quote_document = QuoteDocument.new
    quote_document.tender_id = tender_id
    quote_document.document = params[:document]
    quote_document.user_id = session[:user_logged_id]


    if quote_document.save
      render :json => { :state => 'valid'}
    end


  end

  def get_documents
    @tender_id = params[:tender_id]
    @quote_document = QuoteDocument.new
    @quote_document_optional = QuoteDocumentOptional.new

    if params[:view].present?
      @quote_documents =  QuoteDocument.where("tender_id = #{@tender_id} and user_id = #{session[:user_logged_id]} and  quote_id = #{params[:quote_id]}")
      @quote_document_optionals = QuoteDocumentOptional.where("tender_id = #{@tender_id} and user_id = #{session[:user_logged_id]} and quote_id = #{params[:quote_id]}")
    else
      @quote_documents =  QuoteDocument.where(:tender_id => @tender_id,:user_id => session[:user_logged_id],:quote_id => nil)
      @quote_document_optionals = QuoteDocumentOptional.where(:tender_id => @tender_id,:user_id => session[:user_logged_id],:quote_id => nil)
    end


    puts "@quote_document_optionals:#{@quote_document_optionals}"
    if params[:preview].present?
      @data = render :partial => 'quotes/preview_document_lists'
    elsif  params[:view].present?
      @data = render :partial => 'quotes/preview_document_lists'
    else
      @data = render :partial => 'quotes/document_lists'
    end

  end

  def delete_documents
     ids = params[:ids]
     @tender_id = params[:tender_id]
     if ids.present?
       ids.each do |id|

         if id.to_i > 0
           QuoteDocument.where(:id => id).delete_all
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