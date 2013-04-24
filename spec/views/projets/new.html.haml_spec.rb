require 'spec_helper'

describe "projets/new" do
  before(:each) do
    assign(:projet, stub_model(Projet).as_new_record)
  end

  it "renders new projet form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", projets_path, "post" do
    end
  end
end
