# -*- coding: utf-8 -*-
require 'spec_helper'

describe Etude do
  it { should belong_to(:projet) }

  it "L'identifiant est calculé en incrémentant le plus grand identifiant de la base" do
    3.times do |i|
      if Etude.count == 0 then plus_grand = 0 else plus_grand = Etude.last._id end
      FactoryGirl.create(:etude,code: i.to_s)._id.should be == plus_grand + 1
    end
  end
  it { should have_field(:stade) }
  it { should validate_presence_of(:stade) }
  it "ne peut avoir que avant_projet, projet, suivinn ou bilan comme stade" do
    expect{FactoryGirl.create(:etude, code: '1', stade: :avant_projet)}.to_not raise_error
    expect{FactoryGirl.create(:etude, code: '2', stade: :projet)}.to_not raise_error
    expect{FactoryGirl.create(:etude, code: '3', stade: :bilan)}.to_not raise_error
    expect{FactoryGirl.create(:etude, code: '4', stade: :suivi01)}.to_not raise_error
    expect{FactoryGirl.create(:etude, code: '5', stade: 'autre')}.to raise_error(Mongoid::Errors::MongoidError,/autre invalide/)
  end
  it { should have_field(:code) }
  it { should validate_presence_of(:code) }
  it { should validate_uniqueness_of(:code).scoped_to(:projet_id) }
  it { should have_field(:description) }
  it { should validate_presence_of(:description) }
  it { should have_field(:date_debut) }
  it { should validate_presence_of(:date_debut) }
  it { should have_field(:duree_projet) }
  it { should validate_presence_of(:duree_projet) }
  it { should have_field(:type_produit) }
  it { should validate_presence_of(:type_produit) }
  it { should validate_inclusion_of(:type_produit) }
  it { should have_field(:duree_vie) }
  it { should have_field(:publie) }
  it { should have_field(:date_publication) }
  it "a une date si elle est publiée" do 
    expect{FactoryGirl.create(:etude, publie: true, date_publication: nil)}.to \
      raise_error(Mongoid::Errors::MongoidError,/Date de publication obligatoire/)
  end
  it "n'a pas de date si elle n'est pas publiée" do
    expect{FactoryGirl.create(:etude, publie: false, date_publication: '2013.01.01')}.to \
      raise_error(Mongoid::Errors::MongoidError,/Pas de date de publication sans publier/)
  end
  it "a une date de publication si publiée et n'en a pas sinon" do
    expect{FactoryGirl.create(:etude, code: '1', publie: true, date_publication: '2013.01.01')}.to_not raise_error
    expect{FactoryGirl.create(:etude, code: '2', publie: false, date_publication: false)}.to_not raise_error
  end
  it "n'a qu'une publication pour chaque stade" do
    projet = FactoryGirl.create(:projet, code: '1')
    expect{FactoryGirl.create(:etude, code: '1', projet_id: projet._id, stade: "projet", publie: true, date_publication: '2013.01.01')}.to_not raise_error 
    expect{FactoryGirl.create(:etude, code: '2', projet_id: projet._id, stade: "projet", publie: true, date_publication: '2013.01.01')}.to \
      raise_error(Mongoid::Errors::MongoidError,/Doublon de publication/)
    projet = FactoryGirl.create(:projet, code: '2')
    expect{FactoryGirl.create(:etude, code: '1', projet_id: projet._id, stade: "projet", publie: true, date_publication: '2013.01.01')}.to_not raise_error
  end
  it { should have_field(:note) }
  it { should have_field(:cout) }
  it { should have_field(:delai_retour) }
  it { should embed_one :etude_strategie }
  it { should embed_one :etude_rentabilite }

end
