require 'rails_helper'

RSpec.describe "header_navs/new", type: :view do
  before(:each) do
    assign(:header_nav, HeaderNav.new())
  end

  it "renders new header_nav form" do
    render

    assert_select "form[action=?][method=?]", header_navs_path, "post" do
    end
  end
end
