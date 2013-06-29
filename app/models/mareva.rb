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
  embedded_in :situation
  field :nom, type: String
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
  embedded_in :fonction
  embedded_in :situation
  embedded_in :etude_rentabilite
  field :description, type: String
  field :nature, type: String
  field :unite, type: Symbol
  field :total, type: Float, default: 0
  field :affiche, type: Boolean, default: true
  embeds_many :montants
  accepts_nested_attributes_for :montants
end

class Somme
  include Mongoid::Document
  embedded_in :direct
  embedded_in :indirect
  field :nature, type: String
  field :unite, type: Symbol
  field :valeur, type: Float
end

class Direct
  include Mongoid::Document
  embedded_in :etude_rentabilite
  field :total, type: Float
  field :commentaires, type: String
  embeds_many :sommes
  embeds_many :details
  embeds_many :calculees
  accepts_nested_attributes_for :sommes,:details,:calculees
end

class Repartition
  include Mongoid::Document
  embedded_in :Indirect
  field :cadre, type: String
  field :pourcent, type: Integer
end
  
class Indirect
  include Mongoid::Document
  include Mongoid::MultiParameterAttributes
  validates_with(CoherenceProjet)
  embedded_in :etude_rentabilite
  field :total, type: Float
  field :somme_pourcent, type: Integer
  field :commentaires, type: String
  embeds_many :details
  embeds_many :calculees
  embeds_many :sommes
  embeds_many :repartitions
  accepts_nested_attributes_for :sommes,:details,:calculees,:repartitions
end

class Situation
  include Mongoid::Document
  include Mongoid::MultiParameterAttributes
  validates_with(CoherenceProjet)
  embedded_in :fonctionnement
  field :titre, type: String # 'actuelle' ou 'cible'
  field :total, type: Float
  field :somme_pourcent, type: Integer
  field :commentaires, type: String
  embeds_many :details
  embeds_many :calculees
  embeds_many :repartitions
  accepts_nested_attributes_for :details,:calculees,:repartitions
end

class Fonction
  include Mongoid::Document
  field :total, type: Float
  embedded_in :etude_rentabilite
  embeds_many :situations
  embeds_many :calculees
  accepts_nested_attributes_for :situations,:calculees
end

class EtpRepart
  include Mongoid::Document
  include Mongoid::MultiParameterAttributes
  validates_with(CoherenceProjet)
  embedded_in :gain
  field :titre, type: String
  field :somme_pourcent, type: Integer
  embeds_many :repartitions
  accepts_nested_attributes_for :repartitions
end

class Gain
  include Mongoid::Document
  field :total, type: Float
  field :commentaires, type: String
  embedded_in :etude_rentabilite
  embeds_many :etp_reparts
  embeds_many :details
  embeds_many :calculees
  accepts_nested_attributes_for :etp_reparts,:details,:calculees
end

class CoutAnnuel
  include Mongoid::Document
  embedded_in :cadre
  field :annee, type: Integer
  field :montant, type:Float
end

class Cadre
  include Mongoid::Document
  embedded_in :etude_rentabilite
  field :cadre, type: String
  field :defaut, type: Integer
  embeds_many :cout_annuels
end

class EtudeRentabilite
  include Mongoid::Document
  field :a_calculer, type: Boolean, default: false
  embedded_in :etude
  embeds_one :direct
  embeds_one :indirect
  embeds_one :fonction
  embeds_one :gain
  embeds_many :cadres
  embeds_many :calculees
end
