require 'spec_helper'

describe "etudes/new" do
  before(:each) do
    assign(:etude, stub_model(Etude,
      :stade => "MyString",
      :code => "MyString",
      :description => "MyString",
      :type_produit => "MyText",
      :date_debut => "MyString",
      :duree_projet => "MyString",
      :duree_vie => 1,
      :publie => false,
      :cout => "MyString",
      :delai_retour => 1.5
    ).as_new_record)
  end

  it "renders new etude form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", etudes_path, "post" do
      assert_select "input#etude_stade[name=?]", "etude[stade]"
      assert_select "input#etude_code[name=?]", "etude[code]"
      assert_select "input#etude_description[name=?]", "etude[description]"
      assert_select "textarea#etude_type_produit[name=?]", "etude[type_produit]"
      assert_select "input#etude_date_debut[name=?]", "etude[date_debut]"
      assert_select "input#etude_duree_projet[name=?]", "etude[duree_projet]"
      assert_select "input#etude_duree_vie[name=?]", "etude[duree_vie]"
      assert_select "input#etude_publie[name=?]", "etude[publie]"
      assert_select "input#etude_cout[name=?]", "etude[cout]"
      assert_select "input#etude_delai_retour[name=?]", "etude[delai_retour]"
    end
  end
end
