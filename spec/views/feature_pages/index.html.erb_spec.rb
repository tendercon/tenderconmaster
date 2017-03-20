require 'rails_helper'

RSpec.describe "feature_pages/index", type: :view do
  before(:each) do
    assign(:feature_pages, [
      FeaturePage.create!(),
      FeaturePage.create!()
    ])
  end

  it "renders a list of feature_pages" do
    render
  end
end
