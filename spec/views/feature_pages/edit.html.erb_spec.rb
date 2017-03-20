require 'rails_helper'

RSpec.describe "feature_pages/edit", type: :view do
  before(:each) do
    @feature_page = assign(:feature_page, FeaturePage.create!())
  end

  it "renders the edit feature_page form" do
    render

    assert_select "form[action=?][method=?]", feature_page_path(@feature_page), "post" do
    end
  end
end
