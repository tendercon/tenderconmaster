require 'rails_helper'

RSpec.describe "CompanyPages", type: :request do
  describe "GET /company_pages" do
    it "works! (now write some real specs)" do
      get company_pages_path
      expect(response).to have_http_status(200)
    end
  end
end
