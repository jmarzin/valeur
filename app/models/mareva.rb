# encoding: utf-8 

class Reponse
  include Mongoid::Document
  embedded_in :groupe
  field :texte, type: String
  field :justification, type: String
  field :choix, type: String
  field :note, type: Float 
  field :options, type: Hash
end

class Groupe
  include Mongoid::Document
  embedded_in :etude_strategie
  embedded_in :groupe
  field :nom, type: String
  field :note, type: Float
  field :appreciation, type: String
  field :seuils, type: Hash
  field :prise_en_compte, type: String
  field :ponderations, type: Hash
  embeds_many :groupes
  embeds_many :reponses
end

class EtudeStrategie
  include Mongoid::Document
  embedded_in :etude
  embeds_many :groupes
end


class Etude_rentabilite
end
