# -*- coding: utf-8 -*-
require 'spec_helper'

describe Projet do
  describe "Calcul des dérives" do
    before(:each) do
      @r_avant_projet = FactoryGirl.build(:resume, _id: 1,stade: :avant_projet,cout: 100,duree: 10)
      @r_projet = FactoryGirl.build(:resume, _id: 2,stade: :projet,cout: 200,duree: 20)
      @r_suivi01 = FactoryGirl.build(:resume, _id: 3,stade: :suivi01,cout: 300,duree: 40)
      @r_bilan = FactoryGirl.build(:resume, _id: 4,stade: :bilan,cout: 400,duree: 80)
    end
    it "la dérive n'existe pas s'il n'y a pas d'étude" do
      projet = FactoryGirl.build(:projet)
      projet.calcul_derives.derive_cout.should be nil
      projet.calcul_derives.derive_duree.should be nil
    end
    it "la dérive n'existe pas s'il n'y a qu'une étude" do
      projet = FactoryGirl.build(:projet,resumes: [@r_projet])
      projet.calcul_derives.derive_cout.should be nil
      projet.calcul_derives.derive_duree.should be nil
    end
    it "la dérive n'existe pas s'il y a 2 études dont un avant_projet" do
      projet = FactoryGirl.build(:projet,resumes: [@r_avant_projet,@r_bilan])
      projet.calcul_derives.derive_cout.should be nil
      projet.calcul_derives.derive_duree.should be nil
    end
    it "s'il y a un avant_projet, un projet et un bilan, le cacul est fait avec projet et bilan" do
      projet = FactoryGirl.build(:projet,resumes: [@r_avant_projet,@r_projet,@r_bilan])
      projet.calcul_derives.derive_cout.should be 100
      projet.calcul_derives.derive_duree.should be 300
    end
  end
end
