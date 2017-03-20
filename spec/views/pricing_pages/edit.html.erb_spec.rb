require 'rails_helper'

RSpec.describe "pricing_pages/edit", type: :view do
  before(:each) do
    @pricing_page = assign(:pricing_page, PricingPage.create!())
  end

  it "renders the edit pricing_page form" do
    render

    assert_select "form[action=?][method=?]", pricing_page_path(@pricing_page), "post" do
    end
  end
end
