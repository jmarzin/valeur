require "spec_helper"

describe EtudesController do
  describe "routing" do

    it "routes to #index" do
      get("/etudes").should route_to("etudes#index")
    end

    it "routes to #new" do
      get("/etudes/new").should route_to("etudes#new")
    end

    it "routes to #show" do
      get("/etudes/1").should route_to("etudes#show", :id => "1")
    end

    it "routes to #edit" do
      get("/etudes/1/edit").should route_to("etudes#edit", :id => "1")
    end

    it "routes to #create" do
      post("/etudes").should route_to("etudes#create")
    end

    it "routes to #update" do
      put("/etudes/1").should route_to("etudes#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/etudes/1").should route_to("etudes#destroy", :id => "1")
    end

  end
end
