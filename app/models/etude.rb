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

  def self.lit_niveau(objet_param,objet_etude)
    @objet_etude = objet_etude
    objet_param.param_groupes.each do |groupe|
      etude_groupe = Groupe.new
      groupe.fields.keys.each do |champ|
        if champ != '_id' then
          etude_groupe[champ]=groupe[champ]
        end
      end
      objet_etude.groupes << etude_groupe
      if groupe.param_groupes && groupe.param_groupes != []
        objet_etude.groupes[-1] = Etude.lit_niveau(groupe,objet_etude.groupes[-1])
      elsif groupe.param_reponses && groupe.param_reponses != []
        groupe.param_reponses.each do |reponse|
          etude_reponse = Reponse.new
          reponse.fields.keys.each do |champ|
            if champ != '_id' then
              etude_reponse[champ]=reponse[champ]
            end
          end
          objet_etude.groupes[-1].reponses << etude_reponse
        end
      end
    end
    objet_etude      
  end

  def lit_strategie
    if self.etude_strategie == nil || self.etude_strategie.groupes == []
      param = Parametrage.where(code: 'Standard').first
      self.etude_strategie = EtudeStrategie.new
      self.etude_strategie = Etude.lit_niveau(param.param_strategie,self.etude_strategie)
    end
    self.etude_strategie
  end    

  def self.calcul_niveau(tableau)
    groupe = tableau[0]
    i = tableau[1]
    params = tableau[2]
    if groupe.groupes && groupe.groupes != []
      groupe.groupes.each do |g|
        t=Etude.calcul_niveau([g,i,params])
        g = t[0]
        i = t[1]
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
        else
          if g.groupes && g.groupes != []
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
      end
      [groupe,i,params]
    else
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
    tableau = Etude.calcul_niveau([self.etude_strategie,0,params])
    self.etude_strategie=tableau[0]
    self.etude_strategie
  end

=begin
#ancienne version avant changement de structure
  def lit_strategie
    if self.etude_strategie == nil || self.etude_strategie.domaines == []
      param = Parametrage.where(code: 'Standard').first
      self.etude_strategie = EtudeStrategie.new
      param.p_strategie.p_domaines.each do |domaine|
        self.etude_strategie.domaines << Domaine.new(nom: domaine.nom,note_ponderee: domaine.note_ponderee)
        domaine.p_categories.each do |categorie|
          self.etude_strategie.domaines[-1].categories << Category.new(nom: categorie.nom,note: categorie.note,\
             seuils: categorie.seuils,coef_selectionne: categorie.coef_selectionne,ponderations: categorie.ponderations)
          if categorie.p_reponses == []
            categorie.p_axes.each do |axe|
              self.etude_strategie.domaines[-1].categories[-1].axes << Axis.new(nom: axe.nom,note: axe.note,seuils: axe.seuils)
              if axe.p_reponses == []
              else
                axe.p_reponses.each do |reponse|
                  self.etude_strategie.domaines[-1].categories[-1].axes[-1].reponses << Reponse.new(texte: reponse.texte,\
                    justification: reponse.justification,choix: reponse.choix,note: reponse.note,options: reponse.options)
                end
              end
            end
          else
            categorie.p_reponses.each do |reponse|
              self.etude_strategie.domaines[-1].categories[-1].reponses << Reponse.new(texte: reponse.texte, justification: reponse.justification,\
                choix: reponse.choix,note: reponse.note,options: reponse.options)
            end
          end
        end
      end             
    end
    self.etude_strategie
  end
=end  
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
