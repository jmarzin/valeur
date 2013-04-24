# encoding: utf-8
# Read about factories at https://github.com/thoughtbot/factory_girl
include RandomText
FactoryGirl.define do
  factory :resume do
  end
  factory :projet do
    code Lorem.word.upcase
    nom Lorem.word.capitalize+" "+Lorem.word
    description Lorem.sentence
    entites_concernees Lorem.sentence
    type_de_produit :front_office
    duree_de_vie 5
    quotation_disic {rand(6)}
  end
end
