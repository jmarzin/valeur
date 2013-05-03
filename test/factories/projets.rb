# encoding: utf-8
# Read about factories at https://github.com/thoughtbot/factory_girl
include RandomText
FactoryGirl.define do
  factory :resume do
    etude_id 0
    stade :avant_projet
    date '2013-01-01'
    cout 100.00
    duree 2.5
    note 7
  end
  factory :projet do
    etat :a_l_etude
    code Lorem.word.upcase
    nom Lorem.word.capitalize+" "+Lorem.word
    ministere 'Finances'
    description Lorem.sentence
    entites_concernees Lorem.sentence
    quotation_disic {rand(6)}
  end
end
