# encoding: utf-8
require 'coherence_projet'

class Resume
  include Mongoid::Document
  field :date, type: Date
  field :cout, type: Float
  field :delai, type: Float
  embedded_in :projet
end

class Projet

  def self.liste_ministeres
    ['Intermin','Aff.Etrangères','Agriculture','Culture','Défense','Ecologie','Finances','Intérieur','Sociaux','Serv. PM']
  end

  def self.liste_quotations
    [nil,0,1,2,3,4,5]
  end

  def liste_etats
    if self.current_state == :accepte && self.resumes == []
      [:accepte,:abandonner]
    else
      ([self.current_state.to_sym] << self.current_state.events.keys).flatten
    end
  end

  include Mongoid::Document
  validates_with(CoherenceProjet)
  field :_id, type:Integer, default: ->{ if Projet.count == 0 then 1 else Projet.last._id + 1 end }
  field :code, type: String
  validates :code, :presence => {:message => "obligatoire"}
  validates :code, :uniqueness => {:message => "doit être unique"}
  field :nom, type: String
  validates :nom, :presence => {:message => "obligatoire"}
  field :ministere, type: String
  validates :ministere, :presence => {:message => "obligatoire"}
  field :public, type: Boolean, default: true
  validates :public, :presence => {:message => "obligatoire"}
  field :etat, type: Symbol
  include Workflow
  workflow_column :etat
  workflow do
    state :a_l_etude do
      event :soumettre, :transitions_to => :soumis
      event :abandonner, :transitions_to => :abandonne
    end
    state :soumis do
      event :accepter, :transitions_to => :accepte
      event :rejeter, :transitions_to => :rejete
    end
    state :accepte do
      event :lancer, :transitions_to => :en_cours
      event :abandonner, :transitions_to => :abandonne
    end
    state :rejete do
      event :re_etudier, :transitions_to => :a_l_etude
      event :abandonner, :transitions_to => :abandonne
    end
    state :en_cours do
      event :terminer, :transitions_to => :termine
      event :arreter, :transitions_to => :arrete
    end
    state :abandonne
    state :termine
    state :arrete
  end
  field :description, type: String
  validates :description, :presence => {:message => "obligatoire"}
  field :entites_concernees, type: String
  validates :entites_concernees, :presence => {:message => "à préciser"}
  field :date_debut, type: Date
  validates :date_debut, :presence => {:message => "obligatoire pour un projet lancé",
	 :if => "[:en_cours,:arrete,:termine].include?(self.current_state)" }
  field :derive_cout, type:Float
  field :derive_delai, type:Float
  field :quotation_disic, type:Integer
  validates :quotation_disic, :inclusion => { :in => [nil,0,1,2,3,4,5],
    :message => "%{value} invalide" }
  embeds_many :resumes
  has_many :etudes

end


