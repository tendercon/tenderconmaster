require "rails_helper"

RSpec.describe HeaderNavsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/header_navs").to route_to("header_navs#index")
    end

    it "routes to #new" do
      expect(:get => "/header_navs/new").to route_to("header_navs#new")
    end

    it "routes to #show" do
      expect(:get => "/header_navs/1").to route_to("header_navs#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/header_navs/1/edit").to route_to("header_navs#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/header_navs").to route_to("header_navs#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/header_navs/1").to route_to("header_navs#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/header_navs/1").to route_to("header_navs#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/header_navs/1").to route_to("header_navs#destroy", :id => "1")
    end

  end
end
