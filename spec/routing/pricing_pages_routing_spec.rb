require "rails_helper"

RSpec.describe PricingPagesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/pricing_pages").to route_to("pricing_pages#index")
    end

    it "routes to #new" do
      expect(:get => "/pricing_pages/new").to route_to("pricing_pages#new")
    end

    it "routes to #show" do
      expect(:get => "/pricing_pages/1").to route_to("pricing_pages#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/pricing_pages/1/edit").to route_to("pricing_pages#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/pricing_pages").to route_to("pricing_pages#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/pricing_pages/1").to route_to("pricing_pages#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/pricing_pages/1").to route_to("pricing_pages#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/pricing_pages/1").to route_to("pricing_pages#destroy", :id => "1")
    end

  end
end
