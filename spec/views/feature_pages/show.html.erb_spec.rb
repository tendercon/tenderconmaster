require 'rails_helper'

RSpec.describe "feature_pages/show", type: :view do
  before(:each) do
    @feature_page = assign(:feature_page, FeaturePage.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
