# encoding: utf-8 

class Reponse
  include Mongoid::Document
  embedded_in :axe
  field :texte, type: String
  field :justification, type: String
  field :cle_sectionnee, type: String
  field :note, type: Float 
  field :option, type: Hash
end

class Axe
  include Mongoid::Document
  embedded_in :categorie
  field :titre, type: String
  field :note, type: Float
  field :appreciation, type: Hash
  embeds_many :reponses
end

class Categorie
  include Mongoid::Document
  embedded_in :analyse
  field :nom, type: String
  field :cle_selectionnee, type: String
  field :note_ponderee, type: Float
  field :ponderation, type: Hash
  embeds_many :axes
end

class Analyse
  include Mongoid::Document
  embedded_in :etude_strategie
  field :nom, type: String
  embeds_many :categories
end

class Etude_strategie
  include Mongoid::Document
  embedded_in :etude
  embeds_many :analyses
end


class Etude_rentabilite
end
