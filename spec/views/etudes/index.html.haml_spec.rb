require 'spec_helper'

describe "etudes/index" do
  before(:each) do
    assign(:etudes, [
      stub_model(Etude,
        :stade => "Stade",
        :code => "Code",
        :description => "Description",
        :type_produit => "MyText",
        :date_debut => "Date Debut",
        :duree_projet => "Duree Projet",
        :duree_vie => 1,
        :publie => false,
        :cout => "Cout",
        :delai_retour => 1.5
      ),
      stub_model(Etude,
        :stade => "Stade",
        :code => "Code",
        :description => "Description",
        :type_produit => "MyText",
        :date_debut => "Date Debut",
        :duree_projet => "Duree Projet",
        :duree_vie => 1,
        :publie => false,
        :cout => "Cout",
        :delai_retour => 1.5
      )
    ])
  end

  it "renders a list of etudes" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Stade".to_s, :count => 2
    assert_select "tr>td", :text => "Code".to_s, :count => 2
    assert_select "tr>td", :text => "Description".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "Date Debut".to_s, :count => 2
    assert_select "tr>td", :text => "Duree Projet".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => "Cout".to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
  end
end
