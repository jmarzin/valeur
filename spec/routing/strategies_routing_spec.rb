require "spec_helper"

describe StrategiesController do
  describe "routing" do

    it "routes to #show" do
      get("/strategies/1").should route_to("strategies#show", :id => "1")
    end

    it "routes to #edit" do
      get("/strategies/1/edit").should route_to("strategies#edit", :id => "1")
    end

    it "routes to #update" do
      put("/strategies/1").should route_to("strategies#update", :id => "1")
    end

  end
end
