# encoding: utf-8 
require 'coherence_projet'
class Etude
  
  def self.val_type_produit
    {:back_office => 10, :front_office => 5}
  end

  def liste_stades
    etude_base = Etude.where(_id: self._id).count
    if etude_base == 0
      if self.projet.resumes.empty?
        return [:avant_projet,:projet,:suivi01,:bilan]
      else
        stade_base = self.projet.resumes[-1].stade
      end
    else
      stade_base = Etude.find(self._id).stade
    end
    if stade_base == :bilan
      return [:bilan]
    elsif stade_base == :avant_projet
      return [:avant_projet,:projet,:bilan]
    elsif stade_base == :projet
      return [:projet,:bilan]
    else
      return [stade_base.to_s.succ.to_sym,:bilan]
    end
  end

  def liste_types_produit
    return [:back_office,:front_office,:specifique]
  end

  def gere_resumes
    # gestion des résumés
    if self.publie then
      if self.projet.resumes.empty? || self.projet.resumes[-1].etude_id != self._id
        self.projet.resumes.push\
          (Resume.new(etude_id: self._id,stade: self.stade,date: self.date_publication,cout: self.cout,duree: self.duree_projet,note: self.note))
      else
        return
      end
    else
      if not self.projet.resumes.empty? && self.projet.resumes[-1].etude_id = self._id
        self.projet.resumes.pop
      else
        return
      end
    end
    Projet.find(self.projet_id).calcul_derives.save!
  end

  def inactif?
    # accessibilité des champs en modification et création
    if self.publie
      if self.projet.resumes[-1].etude_id == self._id
        "partiel"
      else
        "total"
      end
    else
      "rien"
    end
  end

  def self.modif_supp_apparents(etudes)
    tab = {}
    etudes.each do |etude|
      if not etude.publie
        tab[etude._id] = {:supp => true,:modif =>true}
      elsif etude.projet.resumes[-1] == etude.stade
        tab[etude._id] = {:supp => false,:modif => true}
      else
        tab[etude._id] = {:supp => false,:modif => false}
      end
    end
    return tab
  end 

  include Mongoid::Document
  include Mongoid::MultiParameterAttributes
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
  field :duree_projet, type: Float
  validates :duree_projet, :presence => {:message => "obligatoire"}
  field :type_produit, type: Symbol
  validates :type_produit, :presence => {:message => "obligatoire"}
  validates :type_produit, :inclusion => { :in => [:back_office,:front_office,:specifique],
    :message => "%{value} invalide" }
  field :duree_vie, type: Integer
  field :publie, type: Boolean, default: false
  field :date_publication, type: Date
  field :note, type: Float  
  validates :note, :presence => {:message => "obligatoire pour une étude publiée",
	 :if => :publie }
  field :cout, type: Float
  validates :cout, :presence => {:message => "obligatoire pour une étude publiée",
	 :if => :publie }
  field :delai_retour, type: Float
  validates :delai_retour, :presence => {:message => "obligatoire pour une étude publiée",
	 :if => :publie }

  embeds_one :etude_strategie
  embeds_one :etude_rentabilite
end
