# encoding: utf-8
require 'spec_helper'

describe Projet do
  it { should have_fields(:code) }
  it { should validate_presence_of(:code) }
  it { should validate_uniqueness_of(:code) }
  it { should have_fields(:nom) }
  it { should validate_presence_of(:nom) }
  it { should have_fields(:ministere) }
  it { should have_fields(:public) }
  it { should validate_presence_of(:public) }
  it { should have_fields(:etat) } # les valeurs prises sont pilotées par le workflow
  it { should have_fields(:description) }
  it { should validate_presence_of(:description) }
  it { should have_fields(:entites_concernees) }
  it { should validate_presence_of(:entites_concernees) }
  it { should have_fields(:date_debut) }
  it { should validate_presence_of(:date_debut) }
  it { should have_fields(:type_de_produit) }
  it { should validate_inclusion_of(:type_de_produit).to_allow([:front_office, :back_office, :valeur]) }
  it { should have_fields(:duree_de_vie) }
  it { should validate_presence_of(:duree_de_vie)}
end
