# encoding: utf-8 
require 'coherence_projet'
#
# la structure des champs option, appreciation et ponderation est voisine
# la clé est le texte qui apparait en choix à l'utilisateur
# la valeur est le coefficient de pondération pour le champ ponderation
#               la note seuil pour le champ appreciation
#               la note pour l'option
# pour les champs pondération et option, le couple "choisissez une option",nil est présent
# 

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

class Etude
  
  def self.val_type_produit
    {:back_office => 10, :front_office => 5}
  end

  def liste_stades
    derniere_etude = Etude.where(projet_id: self.projet_id).last
    if not derniere_etude
      return [:avant_projet,:projet,:suivi01,:bilan]
    end
    base = derniere_etude.stade
    if derniere_etude.publie
      if derniere_etude._id == self._id
        return [base]
      end
      if base =~ /suivi\d\d/
        liste = [base.succ]
      elsif base == :bilan
        liste = [:bilan]
      else
        liste = []
      end
    else
      liste = [base]
    end
    if base == :avant_projet
      liste_aj = [:projet,:suivi01,:bilan]
    elsif base == :projet
      liste_aj = [:suivi01,:bilan]
    elsif base =~ /suivi\d\d/
      liste_aj = [:bilan]
    else
      liste_aj = []
    end
    liste_aj.each do |st| liste <<= st end
    return liste
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
      if (not self.projet.resumes.empty?) && self.projet.resumes[-1].etude_id = self._id
        self.projet.resumes.pop
      else
        return
      end
    end
    Projet.find(self.projet_id).calcul_derives.save!
  end

  def inactif
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
      if (not etude.publie) || etude.projet.resumes.empty?
        tab[etude._id] = {:supp => true,:modif =>true}
      elsif etude.projet.resumes[-1].stade == etude.stade
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
