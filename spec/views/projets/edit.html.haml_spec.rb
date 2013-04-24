require 'spec_helper'

describe "projets/edit" do
  before(:each) do
    @projet = assign(:projet, stub_model(Projet))
  end

  it "renders the edit projet form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", projet_path(@projet), "post" do
    end
  end
end
