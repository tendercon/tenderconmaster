require 'rails_helper'

RSpec.describe "HeaderNavs", type: :request do
  describe "GET /header_navs" do
    it "works! (now write some real specs)" do
      get header_navs_path
      expect(response).to have_http_status(200)
    end
  end
end
