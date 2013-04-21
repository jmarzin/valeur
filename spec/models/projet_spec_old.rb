# encoding: utf-8
require 'spec_helper'

describe Projet do
  describe "contrôle du workflow" do
    before(:each) { @projet = FactoryGirl.build(:projet) ; p @projet ; p @projet.current_state.events ; p @projet.current_state } # }
    describe "cas statut a_l_etude" do
      it "un nouveau projet a le statut a_l_etude" do
        p @projet.current_state
        @projet.a_l_etude?.should be_true
      end
      it "un projet à l'étude qu'on abandonne devient abandonné" do
        @projet.current_state.events[:abandonner].transitions_to.should be :abandonne
      end
      it "un projet à l'étude qu'on soumet devient soumis" do
        @projet.current_state.events[:soumettre].transitions_to.should be :soumis
      end
      it "pas d'autres évènements gérés" do
        @projet.current_state.events.keys.sort.should == [:abandonner,:soumettre]
      end
      before(:each) { @projet.soumettre! }
      describe "cas statut soumis" do
        it "un projet soumis peut être accepté" do
          @projet.current_state.events[:accepter].transitions_to.should be :accepte
        end
        it "un projet soumis peut être rejeté" do
          @projet.current_state.events[:rejeter].transitions_to.should be :rejete
        end
        it "pas d'autres évènements gérés" do
          @projet.current_state.events.keys.sort.should == [:accepter,:rejeter]
        end
      end
    end
#    describe "cas statut accepte" do
#      before(:each) do
#        @projet = FactoryGirl.build(:projet)
#        @projet.soumettre!
#        @projet.accepter!
#      end 
#      it "un projet accepté peut être lancé" do
#        @projet.current_state.events[:lancer].transitions_to.should be :en_cours
#      end
#      it "un projet accepté peut être abandonné" do
#        @projet.current_state.events[:abandonner].transitions_to.should be :abandonne
#      end
#      it "pas d'autres évènements gérés" do
#        @projet.current_state.events.keys.sort.should == [:abandonner,:lancer]
#      end
#    end
#    describe "cas statut en cours" do
#      before(:each) do
#        @projet = FactoryGirl.build(:projet)
#        @projet.soumettre!
#        @projet.accepter!
#        @projet.lancer!
#      end
#      it "un projet en cours peut se terminer" do
#        @projet.current_state.events[:terminer].transitions_to.should be :termine
#      end
#      it "un projet en cours peut être abandonné" do
#        @projet.current_state.events[:abandonner].transitions_to.should be :abandonne
#      end
#      it "pas d'autres évènements gérés" do
#        @projet.current_state.events.keys.sort.should == [:abandonner,:terminer]
#      end
#    end
#    describe "cas statut refusé" do
#      before(:each) do
#        @projet = FactoryGirl.build(:projet)
#        @projet.soumettre!
#        @projet.rejeter!
#      end
#      it "un projet rejeté peut être ré-étudier" do
#        @projet.current_state.events[:re_etudier].transitions_to.should be :a_l_etude
#      end
#      it "un projet rejeté peut être abandonné" do
#        @projet.current_state.events[:abandonner].transitions_to.should be :abandonne
#      end
#      it "Pas d'autres évènements gérés pour un projet rejeté" do
#        @projet.current_state.events.keys.sort.should == [:abandonner,:re_etudier]
#      end
#    end
  end
end
