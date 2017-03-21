class PricingPagesController < ApplicationController
  before_action :set_pricing_page, only: [:show, :edit, :update, :destroy]

  # GET /pricing_pages
  # GET /pricing_pages.json
  def index
    @pricing_pages = PricingPage.all
  end

  # GET /pricing_pages/1
  # GET /pricing_pages/1.json
  def show
  end

  # GET /pricing_pages/new
  def new
    @pricing_page = PricingPage.new
  end

  # GET /pricing_pages/1/edit
  def edit
  end

  # POST /pricing_pages
  # POST /pricing_pages.json
  def create
    @pricing_page = PricingPage.new(pricing_page_params)

    if @pricing_page.save
      redirect_to pricing_pages_path
    else
      render :new
    end
  end

  # PATCH/PUT /pricing_pages/1
  # PATCH/PUT /pricing_pages/1.json
  def update
    @pricing_page = PricingPage.find(params[:id])
    if @pricing_page.update(pricing_page_params)
      redirect_to pricing_pages_path
    else
      render :get_price
    end
  end

  # DELETE /pricing_pages/1
  # DELETE /pricing_pages/1.json
  def destroy
    @pricing_page.destroy
    respond_to do |format|
      format.html { redirect_to pricing_pages_url, notice: 'Pricing page was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def get_price
    @pricing_page = PricingPage.find(params[:id])
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pricing_page
      @pricing_page = PricingPage.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def pricing_page_params
      params.require(:pricing_page).permit(:id,:headline,:intro,:pricing_block,:scrollto_pricing_block,:scrollto_faqs_block,:block_heading,
                                           :item_heading,:item_intro,:currency,:number,:unit,:sign_up_now,:tender_limit,
                                           :item_heading2,:item_intro2,:currency2,:number2,:unit2,:sign_up_now2,:tender_limit2,
                                           :item_heading3,:item_intro3,:currency3,:number3,:unit3,:sign_up_now3,:tender_limit3,
                                           :frequently_block_heading,:faq1,:faq2,:faq3,:faq4,:faq5,:faq6,:faq7,:faq8,
                                           :faq1_desc,:faq2_desc,:faq3_desc,:faq4_desc,:faq5_desc,:faq6_desc,:faq7_desc,:faq8_desc, :tender_limit1_1,:tender_limit1_2,:tender_limit1_3,:tender_limit1_4,:tender_limit1_5,:tender_limit1_6,:tender_limit1_7,:tender_limit1_8,
                                           :tender_limit1_9,:tender_limit1_0,:tender_limit1_11,:tender_limit1_12,:tender_limit1_13,
                                           :tender_limit2_1,:tender_limit2_2,:tender_limit2_3,:tender_limit2_4,:tender_limit2_5,:tender_limit2_6,:tender_limit2_7,:tender_limit2_8,
                                           :tender_limit2_9,:tender_limit2_0,:tender_limit2_11,:tender_limit2_12,:tender_limit2_13,:tender_limit2_14,
                                           :tender_limit3_1,:tender_limit3_2,:tender_limit3_3,:tender_limit3_4,:tender_limit3_5,:tender_limit3_6,:tender_limit3_7,:tender_limit3_8,
                                           :tender_limit3_9,:tender_limit3_0,:tender_limit3_11,:tender_limit3_12,:tender_limit3_13,:tender_limit3_14)
    end
end
