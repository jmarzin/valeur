# encoding: utf-8 
require 'coherence_projet'
class Etude
  include Mongoid::Document
  validates_with(CoherenceProjet)
  belongs_to :projet
  field :_id, type: Integer, default: ->{ if Etude.count == 0 then 1 else Etude.last._id + 1 end }
  field :stade, type: Symbol
  validates :stade, :presence => {:message => "obligatoire"}
  field :code, type: String
  validates :code, :presence => {:message => "obligatoire"}
  validates :code, :uniqueness => {:scope => :projet_id, :message => "doit être unique"}
  field :description, type: String
  validates :description, :presence => {:message => "obligatoire"}
  field :date_debut, type: Date
  validates :date_debut, :presence => {:message => "obligatoire"}
  field :duree_projet, type: Integer
  validates :duree_projet, :presence => {:message => "obligatoire"}
  field :type_produit, type: Symbol
  validates :type_produit, :presence => {:message => "obligatoire"}
  validates :type_produit, :inclusion => { :in => [:back_office,:front_office,:specifique],
    :message => "%{value} invalide" }
  field :duree_vie, type: Integer
  validates :duree_vie, :presence => {:message => "obligatoire"}
  field :publie, type: Boolean, default: false
  field :date_publication, type: Date
  field :note, type: Float
  field :cout, type: Float
  field :delai_retour, type: Float

  embeds_one :etude_strategie
  embeds_one :etude_rentabilite
end