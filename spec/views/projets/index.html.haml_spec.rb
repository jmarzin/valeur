require 'spec_helper'

describe "projets/index" do
  before(:each) do
    assign(:projets, [
      stub_model(Projet),
      stub_model(Projet)
    ])
  end

  it "renders a list of projets" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
