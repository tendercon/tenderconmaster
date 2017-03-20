class ContactPagesController < ApplicationController
  before_action :set_contact_page, only: [:show, :edit, :update, :destroy]

  # GET /contact_pages
  # GET /contact_pages.json
  def index
    @contact_pages = ContactPage.all
  end

  # GET /contact_pages/1
  # GET /contact_pages/1.json
  def show
  end

  # GET /contact_pages/new
  def new
    @contact_page = ContactPage.new
  end

  # GET /contact_pages/1/edit
  def edit
  end

  # POST /contact_pages
  # POST /contact_pages.json
  def create
    @contact_page = ContactPage.new(contact_page_params)

    if @contact_page.save
      redirect_to contact_pages_path
    else
      render :new
    end
  end

  # PATCH/PUT /contact_pages/1
  # PATCH/PUT /contact_pages/1.json
  def update
    @contact_page = ContactPage.find(params[:id])
    if @contact_page.update(pricing_page_params)
      redirect_to contact_pages_path
    else
      render :get_contact
    end
  end

  # DELETE /contact_pages/1
  # DELETE /contact_pages/1.json
  def destroy
    @contact_page.destroy
    respond_to do |format|
      format.html { redirect_to contact_pages_url, notice: 'Contact page was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def get_contact
    @contact_page = ContactPage.find(params[:id])
  end

  def sent_contact
    email = params[:email];
    company = "unknown"
    name = params[:name]
    position = "unknown"
    message = params[:message]
    TenderconMailer.home_notifcation('New Notification','info@tendercon.com',email,company,name,position,message).deliver_now
    flash[:notice] = "Request Submit"
    redirect_to :back
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contact_page
      @contact_page = ContactPage.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def contact_page_params
      params.require(:contact_page).permit(:id,:headline,:meta,:form_title,:name,:email,:message,:sent_it)
    end
end
