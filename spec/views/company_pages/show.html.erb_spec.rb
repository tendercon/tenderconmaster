require 'rails_helper'

RSpec.describe "company_pages/show", type: :view do
  before(:each) do
    @company_page = assign(:company_page, CompanyPage.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
