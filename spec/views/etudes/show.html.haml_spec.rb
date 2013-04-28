require 'spec_helper'

describe "etudes/show" do
  before(:each) do
    @etude = assign(:etude, stub_model(Etude,
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
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Stade/)
    rendered.should match(/Code/)
    rendered.should match(/Description/)
    rendered.should match(/MyText/)
    rendered.should match(/Date Debut/)
    rendered.should match(/Duree Projet/)
    rendered.should match(/1/)
    rendered.should match(/false/)
    rendered.should match(/Cout/)
    rendered.should match(/1.5/)
  end
end
