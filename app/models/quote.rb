class Quote < ActiveRecord::Base
  belongs_to :user
  belongs_to :tender
  has_many   :quote_documents
  has_many   :quote_document_optionals


  def self.quote_link quote,hc_user,trade,project_name,avatar_path
    Prawn::Document.generate  "#{Rails.root}/public/assets/quotes/#{project_name}/#{quote.ref_no}.pdf" do |a|
      puts "------------> djhsjdhjs"
      if avatar_path.present?
        a.image open(avatar_path), :width => 100,:height => 100, position:  :right
      end

      a.text "Ref #:                                                                                                   Company: ", size: 12, style: :bold, color: "000000"
      a.move_down 10
      a.text "#{quote.ref_no}                                                                                                #{hc_user.company}"
      a.move_down 10
      a.text "To                                                                                                         From:", size: 12, style: :bold, color: "000000"
      a.move_down 10
      a.text "#{quote.to}                                                                     #{hc_user.first_name} #{hc_user.last_name}"
      a.move_down 10
      a.text "Attention", size: 12, style: :bold, color: "000000"
      a.move_down 10
      a.text "#{quote.attention}"
      a.text "Date", size: 12, style: :bold, color: "000000"
      a.move_down 10
      a.text "#{quote.quote_date}"
      a.text "Trade", size: 12, style: :bold, color: "000000"
      a.move_down 10
      a.text "#{trade.name}"
      a.text "Title", size: 12, style: :bold, color: "000000"
      a.move_down 10
      a.text "#{quote.title}"
      a.text "Description", size: 12, style: :bold, color: "000000"
      a.move_down 10
      a.text "#{quote.description}"

      if quote.quote_documents.present?
        a.move_down 30
        a.text "Document Uploaded"
        if quote.quote_documents.present?
          quote.quote_documents.each do |d|
            a.move_down 5
            a.text "#{d.document_file_name}", :align => :center
            a.move_down 5
          end
        end
      end

      if quote.quote_document_optionals.present?
        a.move_down 30
        a.text "Supporting Files"
        if quote.quote_document_optionals.present?
          quote.quote_document_optionals.each do |d|
            a.move_down 5
            a.text "#{d.document_file_name}", :align => :center
            a.move_down 5
          end
        end
      end
    end
  end

end