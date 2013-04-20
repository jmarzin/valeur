require "spec_helper"

describe ProjetsController do
  describe "routing" do

    it "routes to #index" do
      get("/projets").should route_to("projets#index")
    end

    it "routes to #new" do
      get("/projets/new").should route_to("projets#new")
    end

    it "routes to #show" do
      get("/projets/1").should route_to("projets#show", :id => "1")
    end

    it "routes to #edit" do
      get("/projets/1/edit").should route_to("projets#edit", :id => "1")
    end

    it "routes to #create" do
      post("/projets").should route_to("projets#create")
    end

    it "routes to #update" do
      put("/projets/1").should route_to("projets#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/projets/1").should route_to("projets#destroy", :id => "1")
    end

  end
end
