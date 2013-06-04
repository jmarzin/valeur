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

class Montant
  include Mongoid::Document
  embedded_in :detail
  embedded_in :calculee
  field :annee, type: String
  field :montant, type: Float
end

class Detail
  include Mongoid::Document
  embedded_in :direct
  embedded_in :indirect
  embedded_in :fonctionnement
  field :description, type: String
  field :nature, type: String
  field :unite, type: Symbol
  field :total, type: Float
  embeds_many :montants
  accepts_nested_attributes_for :montants
end

class Calculee
  include Mongoid::Document
  embedded_in :direct
  embedded_in :indirect
  embedded_in :fonctionnement
  field :description, type: String
  field :nature, type: String
  field :unite, type: Symbol
  field :total, type: Float
  embeds_many :montants
  accepts_nested_attributes_for :montants
end

class Somme
  include Mongoid::Document
  embedded_in :direct
  embedded_in :indirect
  embedded_in :fonctionnement
  field :nature, type: String
  field :unite, type: Symbol
  field :valeur, type: Float
  field :commentaire, type: String
end

class Direct
  include Mongoid::Document
  embedded_in :etude_rentabilite
  field :total, type: Float
  embeds_many :sommes
  embeds_many :details
  embeds_many :calculees
  accepts_nested_attributes_for :sommes,:details,:calculees
end

class Indirect
  include Mongoid::Document
  embedded_in :etude_rentabilite
  field :cat_aplus, type: Integer
  field :cat_a, type: Integer
  field :cat_b, type: Integer
  field :cat_c, type: Integer
  field :total, type: Float
  embeds_many :details
  embeds_many :calculees
  embeds_many :sommes
end


class Fonctionnement
  include Mongoid::Document
  embedded_in :impact_fonctionnement
  embeds_many :details
  embeds_many :calculees
  field :reference, type: Symbol  # :actuel ou :cible
  field :part_cadre, type: Hash # :categorie, pourcentage en valeur, total = 100
end

class ImpactFonctionnement
  include Mongoid::Document
  embedded_in :etude_rentabilite
  embeds_many :fonctionnements
end

class EtudeRentabilite
  include Mongoid::Document
  embedded_in :etude
  embeds_one :direct
  embeds_one :indirect
  embeds_one :impact_fonctionnement
end
