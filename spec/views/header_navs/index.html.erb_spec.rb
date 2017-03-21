require 'rails_helper'

RSpec.describe "header_navs/index", type: :view do
  before(:each) do
    assign(:header_navs, [
      HeaderNav.create!(),
      HeaderNav.create!()
    ])
  end

  it "renders a list of header_navs" do
    render
  end
end
