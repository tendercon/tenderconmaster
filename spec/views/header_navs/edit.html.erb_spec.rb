require 'rails_helper'

RSpec.describe "header_navs/edit", type: :view do
  before(:each) do
    @header_nav = assign(:header_nav, HeaderNav.create!())
  end

  it "renders the edit header_nav form" do
    render

    assert_select "form[action=?][method=?]", header_nav_path(@header_nav), "post" do
    end
  end
end
