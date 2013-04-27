# encoding: utf-8
# Read about factories at https://github.com/thoughtbot/factory_girl
include RandomText
FactoryGirl.define do
  factory :resume do
    date '2013-01-01'
    cout 100.00
    dr 2.5
  end
  factory :projet do
    code Lorem.word.upcase
    nom Lorem.word.capitalize+" "+Lorem.word
    ministere 'Finances'
    description Lorem.sentence
    entites_concernees Lorem.sentence
    quotation_disic {rand(6)}
  end
end
