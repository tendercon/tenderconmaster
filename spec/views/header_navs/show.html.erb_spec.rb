require 'rails_helper'

RSpec.describe "header_navs/show", type: :view do
  before(:each) do
    @header_nav = assign(:header_nav, HeaderNav.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
