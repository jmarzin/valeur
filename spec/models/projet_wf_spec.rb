# encoding: utf-8
require 'spec_helper'

describe Projet do
  describe "Contrôle du workflow" do
    before(:each) { @projet = FactoryGirl.build(:projet) }
    describe "Cas statut a_l_etude" do
      it "Un nouveau projet a le statut a_l_etude" do
        @projet.a_l_etude?.should be_true
      end
      it "Un projet à l'étude qu'on abandonne devient abandonné" do
        @projet.current_state.events[:abandonner].transitions_to.should be :abandonne
      end
      it "Un projet à l'étude qu'on soumet devient soumis" do
        @projet.current_state.events[:soumettre].transitions_to.should be :soumis
      end
      it "Pas d'autres évènements gérés pour un projet à l'étude" do
        @projet.current_state.events.keys.sort.should == [:abandonner,:soumettre]
      end
      describe "Cas statut soumis" do
        before(:each) { @projet.soumettre! }
        it "Un projet soumis peut être accepté" do
          @projet.current_state.events[:accepter].transitions_to.should be :accepte
        end
        it "Un projet soumis peut être rejeté" do
          @projet.current_state.events[:rejeter].transitions_to.should be :rejete
        end
        it "Pas d'autres évènements gérés pour un projet soumis" do
          @projet.current_state.events.keys.sort.should == [:accepter,:rejeter]
        end
        describe "Cas statut accepté" do
          before(:each) { @projet.accepter! }
          it "Un projet accepté peut être lancé" do
            @projet.current_state.events[:lancer].transitions_to.should be :en_cours
          end
          it "Un projet accepté peut être abandonné" do
            @projet.current_state.events[:abandonner].transitions_to.should be :abandonne
          end
          it "Pas d'autres évènements gérés pour un projet accepté" do
            @projet.current_state.events.keys.sort.should == [:abandonner,:lancer]
          end
          describe "Cas statut en cours" do
            before(:each) { @projet.lancer! }
            it "Un projet en cours peut se terminer" do
              @projet.current_state.events[:terminer].transitions_to.should be :termine
            end
            it "Un projet en cours peut être arrêté" do
              @projet.current_state.events[:arreter].transitions_to.should be :arrete
            end
            it "Pas d'autres évènements gérés pour un projet en cours" do
              @projet.current_state.events.keys.sort.should == [:arreter,:terminer]
            end
            describe "Cas statut terminé" do
              it "Un projet terminé ne peut plus évoluer" do
                @projet.terminer!
                @projet.current_state.events.should be_empty
              end
            end
            describe "Cas statut arrêté" do
              it "Un projet arrêté ne peut plus évoluer" do
                @projet.arreter!
                @projet.current_state.events.should be_empty
              end
            end
          end
          describe "Cas statut abandonné" do
            it "Un projet abandonné ne peut plus évoluer" do
              @projet.abandonner!
              @projet.current_state.events.should be_empty
            end
          end
        end
        describe "Cas statut rejeté" do
          before(:each) { @projet.rejeter! }
          it "Un projet rejeté peut être ré étudié" do
            @projet.current_state.events[:re_etudier].transitions_to.should be :a_l_etude
          end
          it "Un projet rejeté peut être abandonné" do
            @projet.current_state.events[:abandonner].transitions_to.should be :abandonne
          end
          it "Pas d'autres évènements pour un projet rejeté" do
            @projet.current_state.events.keys.sort.should == [:abandonner,:re_etudier]
          end
        end
      end
    end
  end
end
