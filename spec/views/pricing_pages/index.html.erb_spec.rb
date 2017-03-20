require 'rails_helper'

RSpec.describe "pricing_pages/index", type: :view do
  before(:each) do
    assign(:pricing_pages, [
      PricingPage.create!(),
      PricingPage.create!()
    ])
  end

  it "renders a list of pricing_pages" do
    render
  end
end
