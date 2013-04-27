# encoding: utf-8
require 'spec_helper'

describe "Gestion des sélecteurs" do
  it "La méthode liste_ministeres ramène un tableau" do
    expect(Projet.liste_ministeres.class).to eq(Array)
  end
  it "La méthode liste_quotations ramène un tableau" do
    expect(Projet.liste_quotations.class).to eq(Array)
  end
  it "La méthode liste_etats ramène un tableau qui contient l'état et actions possibles" do
    projet = FactoryGirl.build(:projet)
    expect(projet.liste_etats).to eq([:a_l_etude,:soumettre,:abandonner])
  end
end
