# encoding: utf-8
# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :projet do
    code "Code"
    nom "Nom"
    description "Description"
    entites_concernees "Entités concernées"
    type_de_produit :front_office
    duree_de_vie 5
  end
end
