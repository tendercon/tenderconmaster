class FeaturePagesController < ApplicationController
  before_action :set_feature_page, only: [:show, :edit, :update, :destroy]

  # GET /feature_pages
  # GET /feature_pages.json
  def index
    @feature_pages = FeaturePage.all.limit(2)
  end

  # GET /feature_pages/1
  # GET /feature_pages/1.json
  def show
  end

  # GET /feature_pages/new
  def new
    @feature_page = FeaturePage.new
    @save_feature_page = FeaturePage.last
  end

  # GET /feature_pages/1/edit
  def edit
    @feature_page = FeaturePage.find(params[:id])
  end

  # POST /feature_pages
  # POST /feature_pages.json
  def create
    @feature_page = FeaturePage.new(feature_page_params)

    #respond_to do |format|
      if @feature_page.save
        redirect_to feature_pages_path
      else
        render :new
      end
    #end
  end

  # PATCH/PUT /feature_pages/1
  # PATCH/PUT /feature_pages/1.json
  def update
    @feature_page = FeaturePage .find(params[:id])
    if @feature_page.update(feature_page_params)
      redirect_to feature_pages_path
    else
      render :get_feature
    end

    # respond_to do |format|
    #   if @feature_page.update(feature_page_params)
    #     format.html { redirect_to @feature_page, notice: 'Feature page was successfully updated.' }
    #     format.json { render :show, status: :ok, location: @feature_page }
    #   else
    #     format.html { render :edit }
    #     format.json { render json: @feature_page.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # DELETE /feature_pages/1
  # DELETE /feature_pages/1.json
  def destroy
    @feature_page.destroy
    respond_to do |format|
      format.html { redirect_to feature_pages_url, notice: 'Feature page was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def get_feature
    @feature_page = FeaturePage.find(params[:id])
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_feature_page
      @feature_page = FeaturePage.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def feature_page_params
      params.require(:feature_page).permit(:id,:page_type,:headline,:tagline,:feature_block_1,:feature_block_2,:feature_block_3,:feature_block_4,
                                   :feature_title,:feature_desc,:feature_title2,:feature_desc2,:feature_title3,:feature_desc3,
                                   :feature_title4,:feature_desc4,:figure_holder,:figure_holder2,:figure_holder3,
                                   :figure_holder4)
    end
end
