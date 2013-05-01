# encoding: utf-8
# Read about factories at https://github.com/thoughtbot/factory_girl
include RandomText
FactoryGirl.define do
  factory :etude do
    code Lorem.word.upcase
    stade :projet
    description Lorem.sentence
    date_debut '2013.01.01'
    duree_projet 8
    type_produit :specifique
    duree_vie 10
  end
end
