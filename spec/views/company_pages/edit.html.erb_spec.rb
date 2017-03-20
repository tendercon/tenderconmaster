require 'rails_helper'

RSpec.describe "company_pages/edit", type: :view do
  before(:each) do
    @company_page = assign(:company_page, CompanyPage.create!())
  end

  it "renders the edit company_page form" do
    render

    assert_select "form[action=?][method=?]", company_page_path(@company_page), "post" do
    end
  end
end
