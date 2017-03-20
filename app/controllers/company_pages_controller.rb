class CompanyPagesController < ApplicationController
  before_action :set_company_page, only: [:show, :edit, :update, :destroy]

  # GET /company_pages
  # GET /company_pages.json
  def index
    @company_pages = CompanyPage.all
  end

  # GET /company_pages/1
  # GET /company_pages/1.json
  def show
  end

  # GET /company_pages/new
  def new
    @company_page = CompanyPage.new
  end

  # GET /company_pages/1/edit
  def edit
  end

  # POST /company_pages
  # POST /company_pages.json
  def create
    @company_page = CompanyPage.new(company_page_params)
    if @company_page.save
      redirect_to company_pages_path
    else
      render :new
    end

  end

  # PATCH/PUT /company_pages/1
  # PATCH/PUT /company_pages/1.json
  def update

    @company_page = CompanyPage.find(params[:id])
    if @company_page.update(company_page_params)
      redirect_to company_pages_path
    else
      render :get_company
    end
  end

  # DELETE /company_pages/1
  # DELETE /company_pages/1.json
  def destroy
    @company_page.destroy
    respond_to do |format|
      format.html { redirect_to company_pages_url, notice: 'Company page was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def get_company
    @company_page = CompanyPage.find(params[:id]  )
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_company_page
      @company_page = CompanyPage.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def company_page_params
      params.require(:company_page).permit(:id,:headline,:intro,:team_block,:block_heading,:block_intro,:ceo_name,:ceo_title,
                                   :ceo_linkedin,:ceo_instagram,:co_founder_name,:co_founder_title,:co_founder_linkedin,
                                   :team_name3,:team_title3,:team_name4,:team_title4,:team_name5, :team_title5,:team_name6,
                                   :team_title6,:team_name7,:team_title7,:team_name8,:team_title8,:ceo_avatar,:co_founder_avatar,
                                   :team3_avatar,:team4_avatar,:team5_avatar,:team6_avatar,:team7_avatar ,:team8_avatar)
    end
end
