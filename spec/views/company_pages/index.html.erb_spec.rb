require 'rails_helper'

RSpec.describe "company_pages/index", type: :view do
  before(:each) do
    assign(:company_pages, [
      CompanyPage.create!(),
      CompanyPage.create!()
    ])
  end

  it "renders a list of company_pages" do
    render
  end
end
