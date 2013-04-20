class Projet
  include Mongoid::Document
  field :code, type: String
  field :nom, type: String
  field :ministere, type: String
  field :public, type: Boolean
  field :etat, type: Symbol
  include Workflow
  workflow_column :etat
  workflow do
    state :a_l_etude do
      event :soumettre, :transitions_to => :soumis
      event :abandonner, :transitions_to => :abandonne
    end
    state :soumis do
      event :accepter, :transitions_to => :approuve
      event :rejeter, :transitions_to => :rejete
    end
    state :abandonne
    state :approuve do
      event :lancer, :transitions_to => :en_cours
      event :abandonner, :transitions_to => :abandonne
    end
    state :rejete do
      event :re_etudier, :transitions_to => :a_l_etude
      event :abandonner, :transitions_to => :abandonne
    end
    state :en_cours do
      event :finir, :transitions_to => :termine
      event :abandonner, :transitions_to => :abandonne
    end
  end
  field :description, type: String
  field :entites_concernees, type: String
  field :date_debut, type: Date
  field :type_de_produit, type: Symbol
  field :duree_de_vie, type: Integer
end
