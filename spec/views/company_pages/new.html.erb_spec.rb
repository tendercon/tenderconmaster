require 'rails_helper'

RSpec.describe "company_pages/new", type: :view do
  before(:each) do
    assign(:company_page, CompanyPage.new())
  end

  it "renders new company_page form" do
    render

    assert_select "form[action=?][method=?]", company_pages_path, "post" do
    end
  end
end
