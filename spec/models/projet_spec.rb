# encoding: utf-8
require 'spec_helper'

describe Projet do
  it "un nouveau projet a le statut a_l_etude" do
    FactoryGirl.build(:projet).a_l_etude?.should be_true
  end
  it "un projet à l'étude qu'on abandonne devient abandonné" do
    projet = FactoryGirl.build(:projet) # Projet.new
    projet.abandonner!.should be_true
    projet.abandonne?.should be_true
  end
end
