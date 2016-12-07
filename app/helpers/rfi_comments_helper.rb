module RfiCommentsHelper

  def get_comment_documents rfi_comment_id

    docs = CommentDocument.where(:rfi_comment_id => rfi_comment_id)

    if docs.present?
      docs
    else
      nil
    end

  end



end