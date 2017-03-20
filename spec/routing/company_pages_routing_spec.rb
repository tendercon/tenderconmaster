require "rails_helper"

RSpec.describe CompanyPagesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/company_pages").to route_to("company_pages#index")
    end

    it "routes to #new" do
      expect(:get => "/company_pages/new").to route_to("company_pages#new")
    end

    it "routes to #show" do
      expect(:get => "/company_pages/1").to route_to("company_pages#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/company_pages/1/edit").to route_to("company_pages#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/company_pages").to route_to("company_pages#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/company_pages/1").to route_to("company_pages#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/company_pages/1").to route_to("company_pages#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/company_pages/1").to route_to("company_pages#destroy", :id => "1")
    end

  end
end
