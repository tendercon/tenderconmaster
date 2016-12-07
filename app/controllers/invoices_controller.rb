class InvoicesController < ApplicationController
  before_filter :is_logged?, except: [:index,:get_invoice]
  layout 'home_layout', :on => [:index,:get_invoice]
  def index
   respond_to do |format|
     format.html
     format.pdf do
       @pdf = Prawn::Document.new(options={:page_layout => :landscape})
       @pdf = InvoicePdf.new()
       send_data @pdf.render, :filename => "invoice_xxxxx.pdf", :type => "application/pdf"
     end
   end

  end

  def get_invoice

  end
end