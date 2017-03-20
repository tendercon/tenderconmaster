require "rails_helper"

RSpec.describe FeaturePagesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/feature_pages").to route_to("feature_pages#index")
    end

    it "routes to #new" do
      expect(:get => "/feature_pages/new").to route_to("feature_pages#new")
    end

    it "routes to #show" do
      expect(:get => "/feature_pages/1").to route_to("feature_pages#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/feature_pages/1/edit").to route_to("feature_pages#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/feature_pages").to route_to("feature_pages#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/feature_pages/1").to route_to("feature_pages#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/feature_pages/1").to route_to("feature_pages#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/feature_pages/1").to route_to("feature_pages#destroy", :id => "1")
    end

  end
end
