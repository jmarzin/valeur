require "spec_helper"

describe EtudesController do
  describe "routing" do
    before(:each) {FactoryGirl.create(:projet)}
    it "routes to #index" do
      get("/projets/1/etudes").should route_to("etudes#index","projet_id"=>"1")
    end

    it "routes to #new" do
      get("/projets/1/etudes/new").should route_to("etudes#new","projet_id"=>"1")
    end

    it "routes to #show" do
      get("/projets/1/etudes/1").should route_to("etudes#show", "projet_id"=>"1", :id => "1")
    end

    it "routes to #edit" do
      get("/projets/1/etudes/1/edit").should route_to("etudes#edit", "projet_id"=>"1", :id => "1")
    end

    it "routes to #create" do
      post("projets/1/etudes").should route_to("etudes#create","projet_id"=>"1")
    end

    it "routes to #update" do
      put("projets/1/etudes/1").should route_to("etudes#update", "projet_id"=>"1", :id => "1")
    end

    it "routes to #destroy" do
      delete("projets/1/etudes/1").should route_to("etudes#destroy", "projet_id"=>"1", :id => "1")
    end

  end
end
