# encoding: utf-8
require 'spec_helper'

describe Projet do
  describe " : le workflow s'initiale à a_l_etude" do
    before(:each) { @projet = FactoryGirl.build(:projet) }
    describe "Cas statut a_l_etude" do
      it "Un nouveau projet a le statut a_l_etude" do
        @projet.etat.should be :a_l_etude
      end
    end
  end
end
