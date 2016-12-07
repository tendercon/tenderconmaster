class CommentDocumentsController < ApplicationController

  def create_comment_document
    tender = Tender.find(params[:tender_id])
    @comment_document = CommentDocument.new
    @comment_document.document = params[:document]
    @comment_document.str_token = params[:token]
    @comment_document.tender_id = params[:tender_id]
    @comment_document.sc_id = session[:user_logged_id]
    @comment_document.rfi_id = session[:rfi_id]
    @comment_document.hc_id = tender.user_id

    if @comment_document.save
      render :json => { :state => 'valid',:str_token => params[:token]}
    end
  end

  def get_documents
    @token = params[:str_token]
    @docs = CommentDocument.where("rfi_comment_id is null")
    @data = render :partial => 'comment_documents/document_lists'
  end

  def delete_documents
    ids = params[:ids]
    @token = params[:token]

    if ids.present?
      ids.each do |a|
        if a != 'on'
          CommentDocument.where(:id => a).delete_all
        end
      end
    end

    if session[:role] == 'Sub Contractor'
      @rfi_documents = CommentDocument.where("sc_id = #{session[:user_logged_id]} and rfi_comment_id is  null")
    elsif session[:role] == 'Head Contractor'
      @rfi_documents = CommentDocument.where("hc_id = #{session[:user_logged_id]} and rfi_comment_id is  null")
    end
    @data = render :partial => 'rfi_comments/get_latest_comment_document'
  end

  def delete_selected_docs
    ids = params[:ids]

    if ids.present?
      ids.each do |a|
        if a != 'on'
          CommentDocument.where(:id => a).delete_all
        end
      end
    end
    @rfi = Rfi.find(params[:rfi_id])
    @comments = RfiComment.where(:rfi_id => params[:rfi_id])
    @data = render :partial => 'rfi_comments/comment_document_lists'
  end
end