require 'rails_helper'

RSpec.describe "FeaturePages", type: :request do
  describe "GET /feature_pages" do
    it "works! (now write some real specs)" do
      get feature_pages_path
      expect(response).to have_http_status(200)
    end
  end
end
