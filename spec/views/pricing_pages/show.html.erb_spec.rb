require 'rails_helper'

RSpec.describe "pricing_pages/show", type: :view do
  before(:each) do
    @pricing_page = assign(:pricing_page, PricingPage.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
