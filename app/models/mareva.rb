# encoding: utf-8 

class Reponse
  include Mongoid::Document
  embedded_in :axe
  field :texte, type: String
  field :justification, type: String
  field :choix, type: String
  field :note, type: Float 
  field :options, type: Hash
end

class Axis
  include Mongoid::Document
  embedded_in :categorie
  field :nom, type: String
  field :note, type: Float
  field :appreciation, type: String
  field :seuils, type: Hash
  embeds_many :reponses
end

class Category
  include Mongoid::Document
  embedded_in :domaine
  field :nom, type: String
  field :note, type: Float
  field :appreciation, type: String
  field :seuils, type: Hash
  field :coef_selectionne, type: String
  field :ponderations, type: Hash
  embeds_many :axes
  embeds_many :reponses
end

class Domaine
  include Mongoid::Document
  embedded_in :etude_strategie
  field :nom, type: String
  field :note_ponderee, type: Float
  embeds_many :categories
end

class EtudeStrategie

  include Mongoid::Document
  embedded_in :etude
  embeds_many :domaines
end


class Etude_rentabilite
end
