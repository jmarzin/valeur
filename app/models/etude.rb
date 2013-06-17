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

  def insere_detail(ins,objet)
    m = /^(.)(\D*)(\d+)/.match(ins)
    if m[1] == 'h' then dec = 1 else dec = 0 end
    if m[2] == 'actuelle'
      obj = objet.situations[0]
    elsif m[2] == 'cible' then
      obj = objet.situations[1]
    else
      obj = objet
    end
    i = m[3].to_i - dec
    j = obj.details.count
    obj.details << Detail.new
    self.liste_annees.each { |annee| obj.details[-1].montants << Montant.new(annee: annee) }
    while j != i
      obj.details[j].nom,obj.details[j-1].nom = obj.details[j-1].nom,obj.details[j].nom
      obj.details[j].description,obj.details[j-1].description = obj.details[j-1].description,obj.details[j].description
      obj.details[j].nature,obj.details[j-1].nature = obj.details[j-1].nature,obj.details[j].nature
      obj.details[j].unite,obj.details[j-1].unite = obj.details[j-1].unite,obj.details[j].unite
      obj.details[j].total,obj.details[j-1].total = obj.details[j-1].total,obj.details[j].total
      self.liste_annees.each_index do |ind|
        obj.details[j].montants[ind].montant,obj.details[j-1].montants[ind].montant = \
          obj.details[j-1].montants[ind].montant,obj.details[j].montants[ind].montant
      end
      j -= 1
    end
    objet.save
    objet
  end

  def supprime_detail(sup,objet)
    m = /^(.)(\D*)(\d+)/.match(sup)
    if m[2] == 'actuelle' then
      obj = objet.situations[0]
    elsif m[2] == 'cible' then
      obj = objet.situations[1]
    else
      obj = objet
    end
    i = m[3].to_i - 1
    obj.details.delete(obj.details[i])
    objet
  end

  def traite_touche(params)
    if params[:indirect] then 
      objet = self.etude_rentabilite.indirect
    elsif params[:direct] then
      objet = self.etude_rentabilite.direct
    elsif params[:fonction] then
      objet = self.etude_rentabilite.fonction
    else
      objet = self.etude_rentabilite.gain
    end
    ins = params.key('Ins^')
    return self.insere_detail(ins,objet) if ins
    ins = params.key('Insv')
    return self.insere_detail(ins,objet) if ins
    return self.supprime_detail(params.key('Sup'),objet)
  end

  def somme_pourcent(params)
    total = 0
    params[:repartitions_attributes].each do |repart|
      total += repart[1][:pourcent].to_i
    end
    params[:somme_pourcent] = total.to_s
    params
  end

  def simplifie_fonction
    self.etude_rentabilite.fonction.situations.each do |situation|
      totaux_annee = Hash.new(0)
      totaux_annee[:ETP] = Hash.new(0)
      totaux_annee[:k€] = Hash.new(0)
      situation.details.where(description: "").destroy_all
      situation.details.where(nature: "").destroy_all
      situation.total = 0
      situation.details.each do |detail|
        detail.unite = Etude.liste_natures_fonctions[detail.nature]
        detail.total = 0
        detail.montants.where(montant: 0).destroy_all
        detail.montants.where(montant: nil).destroy_all
        detail.montants.each do |mt|
          detail.total += mt.montant
          totaux_annee[detail.unite][mt.annee] += mt.montant
        end
        situation.total += detail.total
      end
      situation.calculees[0].total = 0
      situation.calculees[0].montants.each do |mt|
        mt.montant = totaux_annee[:ETP][mt.annee]
        situation.calculees[0].total += mt.montant if mt.montant
      end
      situation.calculees[0].montants.each_index do |i|
        mt = situation.calculees[0].montants[i]
        if mt.montant && mt.montant == 0
          situation.calculees[1].montants[i].montant = 0
        else
          cout_moyen = 0
          situation.repartitions.each do |repart|
            if repart.pourcent && repart.pourcent != 0
              cadre = self.etude_rentabilite.cadres.where(cadre: repart.cadre).first
              cout_moyen += repart.pourcent * cadre.cout_annuels.where(:annee => mt.annee.match(/(\d+)/)[1]).first.montant
            end
          end
          situation.calculees[1].montants[i].montant = cout_moyen/100
        end
      end
      situation.calculees[2].total = 0
      situation.calculees[0].montants.each_index do |i|
        if situation.calculees[0].montants[i].montant != 0
          situation.calculees[2].montants[i].montant = situation.calculees[0].montants[i].montant * \
                                                       situation.calculees[1].montants[i].montant
          situation.calculees[2].total += situation.calculees[2].montants[i].montant
        else
          situation.calculees[2].montants[i].montant = 0
        end
      end
      situation.calculees[3].total = 0
      situation.calculees[3].montants.each do |mt|
        mt.montant = totaux_annee[:k€][mt.annee]
        situation.calculees[3].total += mt.montant if mt.montant 
      end
      situation.calculees[4].total = 0
      situation.calculees[2].montants.each_index do |i|
        situation.calculees[4].montants[i].montant = situation.calculees[2].montants[i].montant
        situation.calculees[4].total += situation.calculees[2].montants[i].montant
        situation.calculees[4].montants[i].montant += situation.calculees[3].montants[i].montant
        situation.calculees[4].total += situation.calculees[3].montants[i].montant
      end
    end
    self.etude_rentabilite.fonction.calculees[0].total = 0
    self.etude_rentabilite.fonction.situations[0].calculees[4].montants.each_index do |i|
      self.etude_rentabilite.fonction.calculees[0].montants[i].montant = self.etude_rentabilite.fonction.situations[1].calculees[4].montants[i].montant - \
                                                                         self.etude_rentabilite.fonction.situations[0].calculees[4].montants[i].montant
      self.etude_rentabilite.fonction.calculees[0].total += self.etude_rentabilite.fonction.calculees[0].montants[i].montant
    end
    self.etude_rentabilite.fonction.total = self.etude_rentabilite.fonction.calculees[0].total
    self.etude_rentabilite.fonction.situations.each do |situation|
      situation.calculees.each do  |calc|
        calc.montants.where(montant: 0).destroy_all
        calc.montants.where(montant: nil).destroy_all
      end
    end
    self.etude_rentabilite.fonction.calculees[0].montants.where(montant: 0).destroy_all
    self.etude_rentabilite.fonction.calculees[0].montants.where(montant: 0).destroy_all
    self.etude_rentabilite.fonction.save
  end

  def simplifie_gain
    totaux_unite_annee = Hash.new
    totaux_nature_unite_annee = Hash.new(0)
    self.etude_rentabilite.gain.details.where(description: "").destroy_all
    self.etude_rentabilite.gain.details.where(nom: "").destroy_all
    self.etude_rentabilite.gain.details.where(nature: "").destroy_all
    self.etude_rentabilite.gain.details.each do |detail|
      detail.unite = 'k€' if detail.unite == ""
      totaux_unite_annee[detail.unite] = Hash.new(0) if not totaux_unite_annee.has_key?(detail.unite)
      totaux_nature_unite_annee[detail.nature] = Hash.new(0) if not totaux_nature_unite_annee.has_key?(detail.nature)
      totaux_nature_unite_annee[detail.nature][detail.unite] = Hash.new(0) if not totaux_nature_unite_annee[detail.nature].has_key?(detail.unite)
      detail.total = 0
      detail.montants.where(montant: 0).destroy_all
      detail.montants.where(montant: nil).destroy_all
      detail.montants.each do |mt|
        detail.total += mt.montant
        totaux_unite_annee[detail.unite][mt.annee] += mt.montant
        totaux_nature_unite_annee[detail.nature][detail.unite][mt.annee] += mt.montant
      end
    end

    self.etude_rentabilite.gain.etp_reparts.each_index do |index|
      cle = self.etude_rentabilite.gain.etp_reparts[index].titre.to_sym
      if totaux_unite_annee[cle] then
        self.etude_rentabilite.gain.calculees[index].total = 0.01
        self.etude_rentabilite.gain.calculees[index].montants.each_index do |i_mt|
          mt = self.etude_rentabilite.gain.calculees[index].montants[i_mt]
          if totaux_unite_annee[cle][mt.annee] != 0 then
            cout_moyen = 0
            self.etude_rentabilite.gain.etp_reparts[index].repartitions.each do |repart|
              if repart.pourcent && repart.pourcent != 0
                cadre = self.etude_rentabilite.cadres.where(cadre: repart.cadre).first
                cout_moyen += repart.pourcent * cadre.cout_annuels.where(:annee => mt.annee.match(/(\d+)/)[1]).first.montant
              end
            end
            self.etude_rentabilite.gain.calculees[index].montants[i_mt].montant = cout_moyen/100            
          else
            self.etude_rentabilite.gain.calculees[index].montants[i_mt].montant = 0
          end
        end
      else
        self.etude_rentabilite.gain.calculees[index].total = 0
        self.etude_rentabilite.gain.calculees[index].montants.each { |mt| mt.montant = 0 }
      end
    end

    Etude.liste_familles_gain.each_index do |index|
      famille = Etude.liste_familles_gain[index]
      if famille != '' then
        self.etude_rentabilite.gain.calculees[index+4].total = 0
        self.etude_rentabilite.gain.calculees[index+4].montants.each { |mt| mt.montant = 0}
        if totaux_nature_unite_annee[famille] != 0
          totaux_nature_unite_annee[famille].each_pair do |unite,annees|
            if unite == :k€ then
              self.etude_rentabilite.gain.calculees[index+4].montants.each do |mt|
                mt.montant += annees[mt.annee]
                self.etude_rentabilite.gain.calculees[index+4].total += annees[mt.annee]
              end
            elsif m=/^ETP(\d+)/.match(unite)
              self.etude_rentabilite.gain.calculees[index+4].montants.each_index do |i|
                annee = self.etude_rentabilite.gain.calculees[index+4].montants[i].annee
                valeur = annees[annee] * self.etude_rentabilite.gain.calculees[m[1].to_i-1].montants[i].montant
                self.etude_rentabilite.gain.calculees[index+4].montants[i].montant += valeur
                self.etude_rentabilite.gain.calculees[index+4].total += valeur
              end
            end
          end
        end
      end
    end

    self.etude_rentabilite.gain.calculees[13].total = 0
    self.etude_rentabilite.gain.calculees[13].montants.each_index do |i|
      self.etude_rentabilite.gain.calculees[13].montants[i].montant = 0
      (5..12).each do |ligne|
        self.etude_rentabilite.gain.calculees[13].montants[i].montant += self.etude_rentabilite.gain.calculees[ligne].montants[i].montant
        self.etude_rentabilite.gain.calculees[13].total += self.etude_rentabilite.gain.calculees[ligne].montants[i].montant
      end
    end
    self.etude_rentabilite.gain.total = self.etude_rentabilite.gain.calculees[13].total
      
    self.etude_rentabilite.gain.calculees.each do  |calc|
      calc.montants.where(montant: 0).destroy_all
      calc.montants.where(montant: nil).destroy_all
    end
    self.etude_rentabilite.gain.save
  end

  def simplifie_indirect
    totaux_nature = Hash.new(0)
    totaux_annee = Hash.new
    totaux_annee[:ETP] = Hash.new(0)
    totaux_annee[:k€] = Hash.new(0)
    self.etude_rentabilite.indirect.details.where(description: "").destroy_all
    self.etude_rentabilite.indirect.details.where(nature: "").destroy_all
    self.etude_rentabilite.indirect.total = 0
    self.etude_rentabilite.indirect.details.each do |detail|
      detail.unite = Etude.liste_natures_indirects[detail.nature]
      detail.total = 0
      detail.montants.where(montant: 0).destroy_all
      detail.montants.where(montant: nil).destroy_all
      detail.montants.each do |mt|
        detail.total += mt.montant
        totaux_annee[detail.unite][mt.annee] += mt.montant
      end
      totaux_nature[detail.nature] += detail.total
      self.etude_rentabilite.indirect.total += detail.total
    end
    self.etude_rentabilite.indirect.sommes.each do |somme|
      somme.montant = totaux_nature[somme.nature]
    end
    self.etude_rentabilite.indirect.calculees[0].montants.each { |mt| mt.montant = totaux_annee[:ETP][mt.annee] }
    self.etude_rentabilite.indirect.calculees[0].total = 0
    self.etude_rentabilite.indirect.calculees[0].montants.each { |mt| self.etude_rentabilite.indirect.calculees[0].total += mt.montant if mt.montant }
    self.etude_rentabilite.indirect.calculees[0].montants.each_index do |i|
      mt = self.etude_rentabilite.indirect.calculees[0].montants[i]
      if mt.montant && mt.montant == 0
        self.etude_rentabilite.indirect.calculees[1].montants[i].montant = 0
      else
        cout_moyen = 0
        self.etude_rentabilite.indirect.repartitions.each do |repart|
          if repart.pourcent && repart.pourcent != 0
            cadre = self.etude_rentabilite.cadres.where(cadre: repart.cadre).first
            cout_moyen += repart.pourcent * cadre.cout_annuels.where(:annee => mt.annee.match(/(\d+)/)[1]).first.montant
          end
        end
        self.etude_rentabilite.indirect.calculees[1].montants[i].montant = cout_moyen/100
      end
    end
    self.etude_rentabilite.indirect.calculees[0].montants.each_index do |i|
      if self.etude_rentabilite.indirect.calculees[0].montants[i].montant != 0
        self.etude_rentabilite.indirect.calculees[2].montants[i].montant = self.etude_rentabilite.indirect.calculees[0].montants[i].montant * \
                                                                           self.etude_rentabilite.indirect.calculees[1].montants[i].montant
      else
        self.etude_rentabilite.indirect.calculees[2].montants[i].montant = 0
      end
    end
    self.etude_rentabilite.indirect.calculees[2].total = 0
    self.etude_rentabilite.indirect.calculees[2].montants.each { |mt| self.etude_rentabilite.indirect.calculees[2].total += mt.montant if mt.montant }
    self.etude_rentabilite.indirect.calculees[3].montants.each { |mt| mt.montant = totaux_annee[:k€][mt.annee] }
    self.etude_rentabilite.indirect.calculees[3].total = 0
    self.etude_rentabilite.indirect.calculees[3].montants.each { |mt| self.etude_rentabilite.indirect.calculees[3].total += mt.montant if mt.montant }
    self.etude_rentabilite.indirect.calculees[4].total = 0
    self.etude_rentabilite.indirect.calculees[2].montants.each_index do |i|
      self.etude_rentabilite.indirect.calculees[4].montants[i].montant = self.etude_rentabilite.indirect.calculees[2].montants[i].montant
      self.etude_rentabilite.indirect.calculees[4].total += self.etude_rentabilite.indirect.calculees[2].montants[i].montant
      self.etude_rentabilite.indirect.calculees[4].montants[i].montant += self.etude_rentabilite.indirect.calculees[3].montants[i].montant
      self.etude_rentabilite.indirect.calculees[4].total += self.etude_rentabilite.indirect.calculees[3].montants[i].montant
    end
    self.etude_rentabilite.indirect.calculees.each do  |calc|
      calc.montants.where(montant: 0).destroy_all
      calc.montants.where(montant: nil).destroy_all
    end
    self.etude_rentabilite.indirect.save
  end

  def simplifie_direct
    totaux_nature = Hash.new(0)
    Etude.liste_natures_directs.each { |nat| totaux_nature[nat] = 0 if nat != '' }
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
    self.etude_rentabilite.direct.save!
  end

  def self.liste_natures_directs
    ['','Logiciel','Matériel','Prestation MOE','Prestation MOA','Formation','Autre']
  end

  def liste_annees
    annee_1 = self.date_debut.year
    liste = ["< #{annee_1}"]
    (annee_1..(annee_1+19)).each {|annee| liste << annee.to_s}
    liste
  end

  def self.liste_natures_indirects
    {'' => '', 'Coûts MOA' => 'ETP', 'Coûts MOE' => 'ETP', 'Formation:temps formateur' => 'ETP', 'Formation:temps stagiaire' => 'ETP',\
      'Autre' => 'ETP', 'Autre' => 'k€'}
  end

  def self.liste_natures_fonctions
    {'' => '', 'Coûts de personnel' => 'ETP', 'Maintenance matériel et infrastructure' => 'k€', 'Maintenance application' => 'k€',\
      'Externalisations' => 'k€', 'Abonnements' => 'k€', 'Autres' => 'k€'}
  end

  def self.repart_defaut
    [{"A" => 80,"B" => 20},{"A" => 80,"B" => 10,"C" => 10},{"B" => 100},{"C" => 100},{"A+" => 100}]
  end

  def self.liste_familles_gain
    ['', 'Augmentation des recettes','Economies induites','Charge de travail','Dépenses additionnelles','Gain trésorerie',\
     'Gain efficacité','Gain productivité','Autres gains']
  end

  def self.liste_unites_gain
    ['','k€','ETP1','ETP2','ETP3','ETP4','ETP5']
  end

  def lit_rentabilite
    if not self.etude_rentabilite
      param = Parametrage.where(code: 'Standard').first
      self.etude_rentabilite = EtudeRentabilite.new
      param.param_rentabilite.param_cadres.each do |p_cad|
        cadre = Cadre.new
        cadre.fields.keys.each { |champ| if champ != '_id' then cadre[champ]=p_cad[champ] end }
        p_cad.param_cout_annuels.each do |p_cout|
          cout_annuel = CoutAnnuel.new
          cout_annuel.fields.keys.each { |champ| if champ != '_id' then cout_annuel[champ]=p_cout[champ] end }
          cadre.cout_annuels << cout_annuel
        end
        self.etude_rentabilite.cadres << cadre
      end
    end
    if not self.etude_rentabilite.direct
      self.etude_rentabilite.direct = Direct.new(total: 0)
      Etude.liste_natures_directs.each {|nature| self.etude_rentabilite.direct.sommes << Somme.new(nature: nature,unite: 'k€',montant: 0) if nature != ''}
    end
    if not self.etude_rentabilite.direct.calculees[0] then self.etude_rentabilite.direct.calculees << Calculee.new(description: 'Totaux (k€)') end
    if not self.etude_rentabilite.indirect then
      self.etude_rentabilite.indirect = Indirect.new(total: 0,somme_pourcent: 100)
      Etude.liste_natures_indirects.each do |nature,unite|
        self.etude_rentabilite.indirect.sommes << Somme.new(nature: nature,unite: unite, montant: 0) if nature != ''
      end
      self.etude_rentabilite.cadres.each do |cadre|
        self.etude_rentabilite.indirect.repartitions << Repartition.new(cadre: cadre.cadre,pourcent: cadre.defaut)
      end
    end
    if self.etude_rentabilite.indirect.calculees.count == 0 then
      self.etude_rentabilite.indirect.calculees << Calculee.new(description: 'Coûts indirects en ETP',unite: 'ETP')\
                                                << Calculee.new(description: 'Coût complet moyen du personnel', unite: 'k€/ETP')\
                                                << Calculee.new(description: 'Coûts indirects existant exprimés en ETP valorisés', unite: 'k€')\
                                                << Calculee.new(description: 'Coûts indirects', unite: 'k€')\
                                                << Calculee.new(description: 'Total des coûts indirects', unite: 'k€')
    end
    if not self.etude_rentabilite.fonction then
      self.etude_rentabilite.fonction = Fonction.new(total: 0,somme_pourcent: 100)
      self.etude_rentabilite.fonction.situations << Situation.new(titre: 'actuelle', total: 0, somme_pourcent: 100)
      self.etude_rentabilite.fonction.situations << Situation.new(titre: 'cible', total: 0, somme_pourcent: 100)
      self.etude_rentabilite.fonction.situations.each do |situation|
        self.etude_rentabilite.cadres.each do |cadre|
          situation.repartitions << Repartition.new(cadre: cadre.cadre, pourcent: cadre.defaut)
        end
        situation.calculees << Calculee.new(description: 'Coûts indirects exprimés en ETP', unite: 'ETP')\
                            << Calculee.new(description: 'Coût complet moyen du personnel', unite: 'k€/ETP')\
                            << Calculee.new(description: 'Coûts indirects exprimés en ETP valorisés', unite: 'k€')\
                            << Calculee.new(description: 'Coûts indirects exprimés en k€', unite: 'k€')\
                            << Calculee.new(description: 'TOTAL COÛTS INDIRECTS', unite: 'k€')
      end
      self.etude_rentabilite.fonction.calculees << Calculee.new(description: 'IMPACTS SUR LES COÛTS DE FONCTIONNEMENT SI', unite: 'k€')
    end
    if not self.etude_rentabilite.gain then
      self.etude_rentabilite.gain = Gain.new(total: 0)
      (1..5).each do |i|
        self.etude_rentabilite.gain.etp_reparts << EtpRepart.new(titre: "ETP#{i}", somme_pourcent: 100)
        self.etude_rentabilite.cadres.each do |cadre|
          self.etude_rentabilite.gain.etp_reparts[i-1].repartitions << Repartition.new(cadre: cadre.cadre, pourcent: Etude.repart_defaut[i-1][cadre.cadre])
        end
      end
      (1..5).each {|i| self.etude_rentabilite.gain.calculees << Calculee.new(description: "Coût complet moyen du personnel modèle ETP#{i}", unite: 'k€/ETP')}
      Etude.liste_familles_gain.each { |famille| self.etude_rentabilite.gain.calculees << Calculee.new(description: famille, unite: 'k€') if famille != ''}
      self.etude_rentabilite.gain.calculees << Calculee.new(description: 'TOTAL IMPACTS METIERS ANNUELS', unite: 'k€')
    end
    self.etude_rentabilite
  end

  def lit_direct_indirect(cas)
    @rentabilite = self.lit_rentabilite
    if cas == 'indirect' then
      base = self.etude_rentabilite.indirect 
    elsif cas == 'direct' then
      base = self.etude_rentabilite.direct
    elsif cas == 'fonction_actuelle' then
      base = self.etude_rentabilite.fonction.situations[0]
    elsif cas == 'fonction_cible' then
      base = self.etude_rentabilite.fonction.situations[1]
    elsif cas == 'fonction' then
      base = self.etude_rentabilite.fonction
    else
      base = self.etude_rentabilite.gain
    end
#
# préparation du tableau des montants par annee
#
    if base.respond_to?(:details)
      if base.details.count == 0 then base.details << Detail.new end
      base.details.each do |detail|
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
    end
#
# préparation de la ligne des totaux par année
#
    base.calculees.each do |calc|
      if calc.montants then mts = calc.montants.clone else mts =[] end
      calc.montants = nil
      self.liste_annees.each do |annee|
        if mts[0] && mts[0].annee == annee
          calc.montants << Montant.new(annee: annee,montant: mts[0].montant)
          mts.delete_at(0)
        else
          calc.montants << Montant.new(annee: annee,montant: 0)
        end
      end
    end
    base
  end

  def lit_fonction
    self.etude_rentabilite.fonction.situations[0] = self.lit_direct_indirect('fonction_actuelle')
    self.etude_rentabilite.fonction.situations[1] = self.lit_direct_indirect('fonction_cible')
    self.etude_rentabilite.fonction = self.lit_direct_indirect('fonction')
    self.etude_rentabilite.fonction
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
