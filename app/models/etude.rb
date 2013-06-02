# encoding: utf-8 
require 'coherence_projet'
require 'mareva'
#
# la structure des champs option, appreciation et ponderation est voisine
# la clé est le texte qui apparait en choix à l'utilisateur
# la valeur est le coefficient de pondération pour le champ ponderation
#               la note seuil pour le champ appreciation
#               la note pour l'option
# pour les champs pondération et option, le couple "choisissez une option",nil est présent
# 


class Etude

  def simplifie_direct
    totaux_nature = Hash.new(0)
    Etude.liste_natures.each { |nat| totaux_nature[nat] = 0 if nat != '' }
    totaux_annee = Hash.new(0)
    self.liste_annees.each { |an| totaux_annee[an] = 0 } 
    self.etude_rentabilite.direct.details.where(description: "").destroy_all
    self.etude_rentabilite.direct.details.where(nature: "").destroy_all
    self.etude_rentabilite.direct.total = 0
    self.etude_rentabilite.direct.details.each do |detail|
      detail.total = 0
      detail.montants.where(montant: 0).destroy_all
      detail.montants.where(montant: nil).destroy_all
      detail.montants.each do |mt|
        detail.total += mt.montant
        totaux_annee[mt.annee] += mt.montant
      end
      totaux_nature[detail.nature] += detail.total
      self.etude_rentabilite.direct.total += detail.total
    end
    self.etude_rentabilite.direct.sommes.each do |somme|
      somme.montant = totaux_nature[somme.nature]
    end
    self.etude_rentabilite.direct.calculees[0].montants.each { |mt| mt.montant = totaux_annee[mt.annee] }
    self.etude_rentabilite.direct.calculees[0].montants.where(montant: 0).destroy_all
    self.etude_rentabilite.direct.calculees[0].montants.where(montant: nil).destroy_all
    self.save!
  end

  def self.liste_natures
    ['','Logiciel','Matériel','Prestation MOE','Prestation MOA','Formation','Autre']
  end

  def liste_annees
    annee_1 = self.date_debut.year
    liste = ["< #{annee_1}"]
    (annee_1..(annee_1+19)).each {|annee| liste << annee.to_s}
    liste
  end

  def lit_rentabilite
    if not self.etude_rentabilite
      self.etude_rentabilite = EtudeRentabilite.new
    end
    if not self.etude_rentabilite.direct
      self.etude_rentabilite.direct = Direct.new(total: 0)
      Etude.liste_natures.each {|nature| self.etude_rentabilite.direct.sommes << Somme.new(nature: nature,unite: 'k€',montant: 0) if nature != ''}
    end
    if not self.etude_rentabilite.direct.calculees[0] then self.etude_rentabilite.direct.calculees << Calculee.new(description: 'Totaux (k€)') end
    self.etude_rentabilite
  end

  def lit_direct
    @rentabilite = self.lit_rentabilite
#
# préparation du tableau des montants par annee
#
    self.etude_rentabilite.direct.details.each do |detail|
      mts = detail.montants.clone
      detail.montants = nil
      self.liste_annees.each do |annee|
        if mts[0] && mts[0].annee == annee
          detail.montants << Montant.new(annee: annee,montant: mts[0].montant)
          mts.delete_at(0)
        else
          detail.montants << Montant.new(annee: annee)
        end
      end
    end
    ((self.etude_rentabilite.direct.details.count)..14).each do |i|
      detail = Detail.new
      self.liste_annees.each {|annee| detail.montants << Montant.new(annee: annee)}
      self.etude_rentabilite.direct.details << detail
    end
#
# préparation de la ligne des totaux par année
#
    if self.etude_rentabilite.direct.calculees[0].montants then mts = self.etude_rentabilite.direct.calculees[0].montants.clone else mts =[] end
    self.etude_rentabilite.direct.calculees[0].montants = nil
    self.liste_annees.each do |annee|
      if mts[0] && mts[0].annee == annee
        self.etude_rentabilite.direct.calculees[0].montants << Montant.new(annee: annee,montant: mts[0].montant)
        mts.delete_at(0)
      else
        self.etude_rentabilite.direct.calculees[0].montants << Montant.new(annee: annee,montant: 0)
      end
    end
    self.etude_rentabilite.direct
  end
        
        
  def self.lit_niveau(objet_param,objet_etude)
#
# lecture récursive des niveaux de paramétrage de la stratégie jusqu'aux questions terminales
# cette méthode est une méthode de classe de la classe étude parce que les méthodes des
# classes de document contenues dans la classe Etude ne peuvent pas être appelées
#
    @objet_etude = objet_etude
    objet_param.param_groupes.each do |groupe|
      etude_groupe = Groupe.new
      groupe.fields.keys.each { |champ| if champ != '_id' then etude_groupe[champ]=groupe[champ] end }
      objet_etude.groupes << etude_groupe
      if groupe.param_groupes && groupe.param_groupes != []
        objet_etude.groupes[-1] = Etude.lit_niveau(groupe,objet_etude.groupes[-1])
      elsif groupe.param_reponses && groupe.param_reponses != []
        groupe.param_reponses.each do |reponse|
          etude_reponse = Reponse.new
          reponse.fields.keys.each { |champ| if champ != '_id' then etude_reponse[champ]=reponse[champ] end }
          objet_etude.groupes[-1].reponses << etude_reponse
        end
      end
    end
    objet_etude      
  end

  def lit_strategie
#
# au cas où il n'y a pas de stratégie définit, lecture de la stratégie standard dans la table de paramétrage
#
    if self.etude_strategie == nil || self.etude_strategie.groupes == []
      param = Parametrage.where(code: 'Standard').first
      self.etude_strategie = EtudeStrategie.new
      self.etude_strategie = Etude.lit_niveau(param.param_strategie,self.etude_strategie)
    end
    self.etude_strategie
  end    

  def self.calcul_niveau(tableau)
#
# méthode de calcul récursif d'un niveau de l'arborescence de groupes de questions
# cette méthode est une méthode de classe de la classe Etude car les méthodes
# d'instance des classes embarquées dans l'étude ne peuvent pas être appelées
#
    groupe , i , params = tableau[0] , tableau[1] , tableau[2]
    if groupe.groupes && groupe.groupes != []
#
#  traitement des sous-groupes
#
      groupe.groupes.each do |g|
        t = Etude.calcul_niveau([g,i,params])
        g , i = t[0] , t[1]
#
#  calcul de la note et de l'appreciation d'un groupe de réponses
#
        if g.reponses && g.reponses != []
          g.note,max = 0,0
          g.reponses.each do |r|
            if g.note
              if r.note
                g.note += r.note
                r_max=0
                r.options.each { |option,note| if note && note > r_max then r_max=note end }
                max += r_max
              else
                g.note=nil
              end
            end
          end
          if g.note
            g.note = (g.note/max*20).round(1)
            g.seuils.each { |apprec,seuil| if g.note >= seuil then g.appreciation=apprec end }
          else
            g.appreciation = nil
          end
        elsif g.groupes && g.groupes != []
#
#  calcul de la note et de l'appreciation d'un groupe de groupes
#
          g.note,somme_poids = 0,0
          g.groupes.each do |g2|
            if g.note
              poids = g2.ponderations[g2.prise_en_compte]
              if g2.note && poids != 0
                g.note += g2.note*poids
                somme_poids += poids 
              else
                g.note = nil
              end
            end
          end
          if g.note
            g.note = (g.note / somme_poids).round(1)
            g.seuils.each { |apprec,seuil| if g.note >= seuil then g.appreciation=apprec end }
          else
            g.appreciation = nil
          end
        end
      end
      [groupe,i,params]
    else
#
# mise à jour de la note, du choix et de la justification de chaque réponse
#
      if groupe.reponses && groupe.reponses != []
        groupe.reponses.each do |r|
          i += 1
          if params[:note][i.to_s] == ""
            r.note = nil
            r.choix = r.options.key(nil)
          else
            r.note = params[:note][i.to_s].to_f
            r.choix = r.options.key(r.note)
          end
          r.justification = params[:justification][i.to_s]
        end
        [groupe,i,params]
      end
    end
  end

  def calcul_strategie(params)
#
# calcul de l'arborescence de stratégie après une modification
#
    tableau = Etude.calcul_niveau([self.etude_strategie,0,params])
    self.etude_strategie=tableau[0]
  end

  def liste_stades
#
# calcule la liste des stades possibles
# 
    derniere_etude = Etude.where(projet_id: self.projet_id).last
    return [:avant_projet,:projet,:suivi01,:bilan] if not derniere_etude
    base = derniere_etude.stade
    if derniere_etude.publie
      return [base] if derniere_etude._id == self._id
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
    liste_aj.each { |st| liste <<= st }
    return liste
  end

  def liste_types_produit
#
# renvoie le tableau des types de produit permis
#
    return [:back_office,:front_office,:specifique]
  end

  def self.val_type_produit
#
# renvoie la durée de vie correspondant aux différents types de produit permis
# 
   {:back_office => 10, :front_office => 5}
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
    # accessibilité des études en modification et suppression
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
