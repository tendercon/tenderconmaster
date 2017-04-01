class HeaderNavsController < ApplicationController
  before_action :set_header_nav, only: [:show, :edit, :update, :destroy]

  # GET /header_navs
  # GET /header_navs.json
  def index
    @header_navs = HeaderNav.all
  end

  # GET /header_navs/1
  # GET /header_navs/1.json
  def show
  end

  # GET /header_navs/new
  def new
    @header_nav = HeaderNav.new
    @save_header = HeaderNav.last
  end

  # GET /header_navs/1/edit
  def edit
  end

  # POST /header_navs
  # POST /header_navs.json
  def create
    @header_nav = HeaderNav.new(header_nav_params)
    if @header_nav.save
      redirect_to header_navs_path
    else
      render :new
    end

  end

  # PATCH/PUT /header_navs/1
  # PATCH/PUT /header_navs/1.json
  def update
    @header_nav = HeaderNav .find(params[:id])
    if @header_nav.update(header_nav_params)
      redirect_to header_navs_path
    else
      render :get_nav
    end

  end

  # DELETE /header_navs/1
  # DELETE /header_navs/1.json
  def destroy
    @header_nav.destroy
    respond_to do |format|
      format.html { redirect_to header_navs_url, notice: 'Header nav was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  def get_nav
    @header_nav = HeaderNav.find(params[:id])
    @save_header = HeaderNav.last
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_header_nav
      if params[:id].to_i > 0
        @header_nav = HeaderNav.find(params[:id])
      end

    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def header_nav_params
      params.require(:header_nav).permit(:id,:page_type,:home,:feature,:pricing,:company,:login,:register, :hide_pricing,:logo)
    end
end
