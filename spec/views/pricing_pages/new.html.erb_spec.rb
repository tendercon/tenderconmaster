require 'rails_helper'

RSpec.describe "pricing_pages/new", type: :view do
  before(:each) do
    assign(:pricing_page, PricingPage.new())
  end

  it "renders new pricing_page form" do
    render

    assert_select "form[action=?][method=?]", pricing_pages_path, "post" do
    end
  end
end
