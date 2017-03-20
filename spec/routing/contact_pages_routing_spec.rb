require "rails_helper"

RSpec.describe ContactPagesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/contact_pages").to route_to("contact_pages#index")
    end

    it "routes to #new" do
      expect(:get => "/contact_pages/new").to route_to("contact_pages#new")
    end

    it "routes to #show" do
      expect(:get => "/contact_pages/1").to route_to("contact_pages#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/contact_pages/1/edit").to route_to("contact_pages#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/contact_pages").to route_to("contact_pages#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/contact_pages/1").to route_to("contact_pages#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/contact_pages/1").to route_to("contact_pages#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/contact_pages/1").to route_to("contact_pages#destroy", :id => "1")
    end

  end
end
