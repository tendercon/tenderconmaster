class RfiCommentsController  < ApplicationController
  skip_before_action :verify_authenticity_token
  def create_comment
    require 'zip'
    message = params[:message]
    rfi_id = params[:rfi_id]
    @rfi = Rfi.find(rfi_id)
    tender = Tender.find(params[:tender_id])
    rfi_comment = RfiComment.new
    rfi_comment.comment = message
    rfi_comment.rfi_id = rfi_id
    rfi_comment.sender =  session[:user_logged_id]

    if session[:role] == 'Head Contractor'
      rfi_comment.hc_id = session[:user_logged_id]
      rfi_comment.sc_id = @rfi.user_id
    else
      rfi_comment.hc_id =  tender.user_id
      rfi_comment.sc_id = session[:user_logged_id]
    end

    str_token = params[:str_token]

    if rfi_comment.save
      if session[:role] == 'Sub Contractor'
        RfiNotification.create_rfi_notification(@rfi.user_id, @rfi.tender_id,tender.user_id,@rfi.id,"#{@rfi.user.company} left a comment on the RFI","SC")
        CommentDocument.where("rfi_comment_id is null and tender_id = #{tender.id} and sc_id = #{session[:user_logged_id]}").update_all(:rfi_comment_id => rfi_comment.id)
      elsif session[:role] == 'Head Contractor'
        RfiNotification.create_rfi_notification(@rfi.user_id, @rfi.tender_id,tender.user_id,@rfi.id,"#{tender.user.company} left a comment on the RFI","HC")
        CommentDocument.where("rfi_comment_id is null and tender_id = #{tender.id}  and hc_id = #{session[:user_logged_id]}").update_all(:rfi_comment_id => rfi_comment.id)
      end

      @comments = RfiComment.where(:rfi_id => rfi_id)
      @comment_documents = CommentDocument.where(:rfi_comment_id => rfi_comment.id)

      if @comment_documents.present?
        dir = "#{Rails.root}/public/assets/comments/#{@rfi.ref_no}-#{rfi_comment.id}"
        Dir.mkdir(dir) unless File.exists?(dir)
        @comment_documents.each do |a|
          FileUtils.cp a.document.path, dir
        end
        @destination =  "#{Rails.root}/public/assets/comments/#{@rfi.ref_no}-#{rfi_comment.id}"
        @destination.sub!(%r[/$],'')

        archive = File.join(@destination,File.basename(@destination))+'.zip'
        FileUtils.rm archive, :force=>true

        Zip::File.open(archive, 'w') do |zipfile|
          Dir["#{@destination}/**/**"].reject{|f|f==archive}.each do |file|
            zipfile.add(file.sub(@destination+'/',''),file)
          end
        end
        File.rename("#{Rails.root}/public/assets/comments/#{@rfi.ref_no}-#{rfi_comment.id}/#{@rfi.ref_no}-#{rfi_comment.id}.zip", "#{Rails.root}/public/assets/comments/#{@rfi.ref_no}-#{rfi_comment.id}/#{@rfi.ref_no}-Supporting Files.zip")
      end

      @data = render :partial => 'rfi_comments/comment_document_lists'
    end

  end
end