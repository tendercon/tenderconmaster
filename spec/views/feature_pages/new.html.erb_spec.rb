require 'rails_helper'

RSpec.describe "feature_pages/new", type: :view do
  before(:each) do
    assign(:feature_page, FeaturePage.new())
  end

  it "renders new feature_page form" do
    render

    assert_select "form[action=?][method=?]", feature_pages_path, "post" do
    end
  end
end
