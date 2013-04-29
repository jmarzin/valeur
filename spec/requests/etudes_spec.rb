require 'spec_helper'

describe "Etudes" do
  describe "GET /etudes" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      @projet = FactoryGirl.create(:projet)
      get projet_etudes_path(@projet)
      response.status.should be(200)
    end
  end
end
