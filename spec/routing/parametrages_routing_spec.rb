require "spec_helper"

describe ParametragesController do
  describe "routing" do

    it "routes to #index" do
      get("/parametrages").should route_to("parametrages#index")
    end

    it "routes to #new" do
      get("/parametrages/new").should route_to("parametrages#new")
    end

    it "routes to #show" do
      get("/parametrages/1").should route_to("parametrages#show", :id => "1")
    end

    it "routes to #edit" do
      get("/parametrages/1/edit").should route_to("parametrages#edit", :id => "1")
    end

    it "routes to #create" do
      post("/parametrages").should route_to("parametrages#create")
    end

    it "routes to #update" do
      put("/parametrages/1").should route_to("parametrages#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/parametrages/1").should route_to("parametrages#destroy", :id => "1")
    end

  end
end
