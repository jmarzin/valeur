# encoding: utf-8
class Projet
  include Mongoid::Document
  field :code, type: String
  validates :code, :presence => {:message => "Le code est obligatoire"}
  validates :code, :uniqueness => {:message => "Le code doit être unique"}
  field :nom, type: String
  validates :nom, :presence => {:message => "Le nom est obligatoire"}
  field :ministere, type: String
  field :public, type: Boolean, default: true
  validates :public, :presence => {:message => "L'indicateur public est obligatoire"}
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
  validates :description, :presence => {:message => "La description est obligatoire"}
  field :entites_concernees, type: String
  validates :entites_concernees, :presence => {:message => "Vous devez préciser les entités concernées"}
  field :date_debut, type: Date
  validates :date_debut, :presence => {:message => "La date de début est obligatoire pour un projet lancé",
	 :if => "[:en_cours,:arrete,:termine].include?(self.current_state)" }
  field :type_de_produit, type: Symbol
  validates :type_de_produit, :inclusion => { :in => [:front_office,:back_office,:valeur],
    :message => "%{value} n'est pas une valeur valide" }
  field :duree_de_vie, type: Integer
  validates :duree_de_vie, :presence => {:message => "La durée de vie du produit est obligatoire"}
end
