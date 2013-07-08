# encoding: utf-8 
require 'coherence_projet'
require 'mareva'
require 'irr'

#
# la structure des champs option, appreciation et ponderation est voisine
# la clé est le texte qui apparait en choix à l'utilisateur
# la valeur est le coefficient de pondération pour le champ ponderation
#               la note seuil pour le champ appreciation
#               la note pour l'option
# pour les champs pondération et option, le couple "choisissez une option",nil est présent
# 


class Etude

  def self.copie(objet,parent)
    la_copie = objet.class.new
    if objet._parent then
      nom_parent = nil
      objet.associations.each do |assoc|
        if assoc[1][:relation] == Mongoid::Relations::Embedded::In then
          nom_parent = assoc[0]
          break
        end
      end
      la_copie.send nom_parent+'=',parent if nom_parent
    end
    objet.fields.each do |champ|
      la_copie[champ[0]] = objet[champ[0]] unless champ[0] == '_id'
    end
    if la_copie.class == Etude then
      la_copie.code = 'Copie de ' + la_copie.code + ' (' + Time.now.tv_sec.to_s + ')'
      la_copie.publie = false
      la_copie.date_publication = nil
    end
    la_copie.save # ajouter avant la référence à l'objet père
    objet.associations.each do |assoc|
      if assoc[1][:relation] == Mongoid::Relations::Embedded::One && objet[assoc[0]]
        la_copie.send assoc[0]+'=', Etude.copie((objet.send assoc[0]),la_copie)
      elsif assoc[1][:relation] == Mongoid::Relations::Embedded::Many && objet[assoc[0]]
        (objet.send assoc[0]).each do |element|
          Etude.copie(element,la_copie)
        end
      end
    end
    la_copie
  end

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

 def self.finalise_calculs(objet,index)
    objet.calculees.each do |calculee|
      calculee.total = 0
      calculee.montants.each { |mt| calculee.total += mt.montant }
      calculee.montants.where(montant: 0).destroy_all
      calculee.montants.where(montant: nil).destroy_all
    end
    objet.total = objet.calculees[index].total
    true
  end

  def simplifie_fonction
    self.etude_rentabilite.fonction.situations.each do |situation|
      totaux = self.reduction_details(situation)
      if totaux[:unite_annee][:ETP] != 0 then
        self.calcul_cout_moyen(situation.repartitions, situation.calculees[0], totaux[:unite_annee][:ETP], situation.calculees[1], situation.calculees[2])
      end
      Etude.cout_mo_total(situation.calculees[3],totaux[:unite_annee][:k€])
      situation.calculees[2].montants.each_index do |i|
        situation.calculees[4].montants[i].montant = situation.calculees[2].montants[i].montant + \
                                                     situation.calculees[3].montants[i].montant
      end
    end
    self.etude_rentabilite.fonction.situations[0].calculees[4].montants.each_index do |i|
      self.etude_rentabilite.fonction.calculees[0].montants[i].montant = self.etude_rentabilite.fonction.situations[1].calculees[4].montants[i].montant - \
                                                                         self.etude_rentabilite.fonction.situations[0].calculees[4].montants[i].montant
    end
    self.etude_rentabilite.fonction.situations.each { |situation| Etude.finalise_calculs(situation,4) }
    Etude.finalise_calculs(self.etude_rentabilite.fonction,0)
    self.etude_rentabilite.save
  end

  def reduction_details(objet)
    totaux_nature = Hash.new(0)
    totaux_nature_unite_annee = Hash.new(0)
    totaux_unite_annee = Hash.new (0)
    objet.details.where(description: "").destroy_all
    objet.details.where(nature: "").destroy_all
    objet.details.each do |detail|
      if objet.class == Gain
        detail.unite = 'k€' if detail.unite == ''
      else
        detail.unite = Etude.liste_natures[objet.class][detail.nature] if objet.class != Gain
      end
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
      totaux_nature[detail.nature] += detail.total
    end
    {:nature => totaux_nature, :unite_annee => totaux_unite_annee, :nature_unite_annee => totaux_nature_unite_annee}
  end

  def self.cout_mo_total(calculee,totaux€)
    if totaux€ != 0
      calculee.montants.each do |mt|
        mt.montant = totaux€[mt.annee]
      end
    else
      calculee.montants.each do |mt|
        mt.montant = 0
      end
    end
    true
  end

  def calcule_cout_moyen_unitaire(totaux_unite_annee,repartitions,calculee)
    calculee.montants.each_index do |i_mt|
      mt = calculee.montants[i_mt]
      if totaux_unite_annee[mt.annee] != 0 then
        cout_moyen = 0
        repartitions.each do |repart|
          if repart.pourcent && repart.pourcent != 0
            cadre = self.etude_rentabilite.cadres.where(cadre: repart.cadre).first
            cout_moyen += repart.pourcent * cadre.cout_annuels.where(:annee => mt.annee.match(/(\d+)/)[1]).first.montant
          end
        end
        calculee.montants[i_mt].montant = cout_moyen/100
      else
        calculee.montants[i_mt].montant = 0
      end
    end
    true            
  end

  def calcul_cout_moyen(repartitions, calculee_nb, totaux_unite_annee, calculee_un, calculee_ts)
    calculee_nb.montants.each { |mt| mt.montant = totaux_unite_annee[mt.annee] }
    self.calcule_cout_moyen_unitaire(totaux_unite_annee,repartitions,calculee_un) unless totaux_unite_annee == 0
    calculee_nb.montants.each_index do |i|
      if calculee_nb.montants[i].montant != 0
        calculee_ts.montants[i].montant = calculee_nb.montants[i].montant * \
                                          calculee_un.montants[i].montant
      else
        calculee_ts.montants[i].montant = 0
      end
    end
    true
  end

  def simplifie_gain
    totaux = self.reduction_details(self.etude_rentabilite.gain)
    self.etude_rentabilite.gain.etp_reparts.each_index do |index|
      cle = self.etude_rentabilite.gain.etp_reparts[index].titre.to_sym
      if totaux[:unite_annee][cle] != 0 then
        self.etude_rentabilite.gain.calculees[index].affiche = true
        self.calcule_cout_moyen_unitaire(totaux[:unite_annee][cle],self.etude_rentabilite.gain.etp_reparts[index].repartitions,\
                                         self.etude_rentabilite.gain.calculees[index])
      else
        self.etude_rentabilite.gain.calculees[index].affiche = false
        self.etude_rentabilite.gain.calculees[index].montants.each { |mt| mt.montant = 0 }
      end
    end
    Etude.liste_familles_gain.each_index do |index|
      famille = Etude.liste_familles_gain[index]
      self.etude_rentabilite.gain.calculees[index+5].montants.each { |mt| mt.montant = 0}
      if totaux[:nature_unite_annee][famille] != 0
        totaux[:nature_unite_annee][famille].each_pair do |unite,annees|
          if unite == :k€ then
            self.etude_rentabilite.gain.calculees[index+5].montants.each do |mt|
              mt.montant += annees[mt.annee]
            end
          elsif m=/^ETP(\d+)/.match(unite)
            self.etude_rentabilite.gain.calculees[index+5].montants.each_index do |i|
              annee = self.etude_rentabilite.gain.calculees[index+5].montants[i].annee
              valeur = annees[annee] * self.etude_rentabilite.gain.calculees[m[1].to_i-1].montants[i].montant
              self.etude_rentabilite.gain.calculees[index+5].montants[i].montant += valeur
            end
          end
        end
      end
    end
    self.etude_rentabilite.gain.calculees[13].montants.each_index do |i|
      self.etude_rentabilite.gain.calculees[13].montants[i].montant = 0
      (5..12).each do |ligne|
        self.etude_rentabilite.gain.calculees[13].montants[i].montant += self.etude_rentabilite.gain.calculees[ligne].montants[i].montant
      end
    end
    Etude.finalise_calculs(self.etude_rentabilite.gain,13)
    self.etude_rentabilite.save
  end

  def simplifie_indirect
    totaux = self.reduction_details(self.etude_rentabilite.indirect)

    self.etude_rentabilite.indirect.sommes.each do |somme|
      somme.valeur = totaux[:nature][somme.nature]
    end
    self.calcul_cout_moyen(self.etude_rentabilite.indirect.repartitions, self.etude_rentabilite.indirect.calculees[0], \
      totaux[:unite_annee][:ETP],self.etude_rentabilite.indirect.calculees[1], self.etude_rentabilite.indirect.calculees[2])

    Etude.cout_mo_total(self.etude_rentabilite.indirect.calculees[3],totaux[:unite_annee][:k€])
    self.etude_rentabilite.indirect.calculees[2].montants.each_index do |i|
      self.etude_rentabilite.indirect.calculees[4].montants[i].montant = self.etude_rentabilite.indirect.calculees[2].montants[i].montant + \
                                                                         self.etude_rentabilite.indirect.calculees[3].montants[i].montant
    end
    Etude.finalise_calculs(self.etude_rentabilite.indirect,4)
    self.etude_rentabilite.save
  end

  def simplifie_direct
    totaux = self.reduction_details(self.etude_rentabilite.direct)
    self.etude_rentabilite.direct.sommes.each do |somme|
      somme.valeur = totaux[:nature][somme.nature]
    end
    self.etude_rentabilite.direct.calculees[0].montants.each { |mt| mt.montant = totaux[:unite_annee][:k€][mt.annee] }
    Etude.finalise_calculs(self.etude_rentabilite.direct,0)
    self.etude_rentabilite.save
  end

  def self.liste_natures
    {Direct => {'Logiciel' =>'k€','Matériel'=>'k€','Prestation MOE'=>'k€','Prestation MOA'=>'k€','Formation'=>'k€','Autre'=>'k€'},\
      Indirect => {'Coûts MOA' => 'ETP', 'Coûts MOE' => 'ETP', 'Formation:temps formateur' => 'ETP', 'Formation:temps stagiaire' => 'ETP',\
      'Autre' => 'ETP', 'Autre' => 'k€' },\
      Situation => {'Coûts de personnel' => 'ETP', 'Maintenance matériel et infrastructure' => 'k€', 'Maintenance application' => 'k€',\
      'Externalisations' => 'k€', 'Abonnements' => 'k€', 'Autres' => 'k€' }}
  end

  def liste_annees
    annee_1 = self.date_debut.year
    liste = ["<= #{annee_1}"]
    ((annee_1+1)..(annee_1+19)).each {|annee| liste << annee.to_s}
    liste
  end

  def self.repart_defaut
    [{"A" => 80,"B" => 20},{"A" => 80,"B" => 10,"C" => 10},{"B" => 100},{"C" => 100},{"A+" => 100}]
  end

  def self.liste_familles_gain
    ['Augmentation des recettes','Economies induites','Charge de travail','Dépenses additionnelles','Gain trésorerie',\
     'Gain efficacité','Gain productivité','Autres gains']
  end

  def self.liste_unites_gain
    ['k€','ETP1','ETP2','ETP3','ETP4','ETP5']
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
    if self.etude_rentabilite.calculees.count == 0 then
      self.etude_rentabilite.calculees << Calculee.new(description: "Total Coûts d'investissement initial",unite: 'k€')
      self.etude_rentabilite.calculees << Calculee.new(description: "Total Coûts d'investissement initial actualisés",unite: 'k€')     
      self.etude_rentabilite.calculees << Calculee.new(description: "Total Impacts Métiers actualisé",unite: 'k€')
      self.etude_rentabilite.calculees << Calculee.new(description: "Total Impacts sur les coûts de fonctionnement SI actualisé",unite: 'k€')
      self.etude_rentabilite.calculees << Calculee.new(description: "Gains nets (Impacts métiers + Impacts fonctionnement système) ",unite: 'k€')
      self.etude_rentabilite.calculees << Calculee.new(description: "TOTAL FLUX ANNUELS non actualisés (k€)",unite: 'k€')
      self.etude_rentabilite.calculees << Calculee.new(description: "TOTAL FLUX ANNUELS actualisés",unite: 'k€')
      self.etude_rentabilite.calculees << Calculee.new(description: "TOTAL FLUX ANNUELS CUMULES actualisés",unite: 'k€')
    end
    if not self.etude_rentabilite.direct
      self.etude_rentabilite.direct = Direct.new(total: 0)
      Etude.liste_natures[Direct].each do |nature,unite| 
        self.etude_rentabilite.direct.sommes << Somme.new(nature: nature,unite: unite,montant: 0)
      end
    end
    if not self.etude_rentabilite.direct.calculees[0] then 
      self.etude_rentabilite.direct.calculees << Calculee.new(description: 'Total des coûts directs',unite:'k€')
    end
    if not self.etude_rentabilite.indirect then
      self.etude_rentabilite.indirect = Indirect.new(total: 0,somme_pourcent: 100)
      Etude.liste_natures[Indirect].each do |nature,unite|
        self.etude_rentabilite.indirect.sommes << Somme.new(nature: nature,unite: unite, montant: 0)
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
                            << Calculee.new(description: "Total des coûts indirects situation #{situation.titre}", unite: 'k€')
      end
      self.etude_rentabilite.fonction.calculees << Calculee.new(description: 'Total Impacts sur les coûts de fonctionnement des systèmes', unite: 'k€')
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
      Etude.liste_familles_gain.each { |famille| self.etude_rentabilite.gain.calculees << Calculee.new(description: famille, unite: 'k€')}
      self.etude_rentabilite.gain.calculees << Calculee.new(description: 'Total des impacts métier', unite: 'k€')
    end
    self.etude_rentabilite.save
    self.etude_rentabilite
  end

  def calcul_somme(calcule,origine,signe)
    i = 0
    calcule.montants.each do |mt|
      if origine.montants[i] && origine.montants[i].annee == mt.annee then
        if signe == '-' then
          mt.montant -= origine.montants[i].montant
          calcule.total -= origine.montants[i].montant
        else
          mt.montant += origine.montants[i].montant
          calcule.total += origine.montants[i].montant
        end
        i += 1
      end
    end
    calcule
  end

  def actualise(calcule, origine,signe)
    facteur = 1+self.taux_actu/100
    i = 0
    calcule.montants.each_index do |rang|
      if origine.montants[i] && origine.montants[i].annee == calcule.montants[rang].annee then
        calcule.montants[rang].montant = origine.montants[i].montant/(facteur**rang)
        calcule.montants[rang].montant = -calcule.montants[rang].montant if signe == '-'
        calcule.total += calcule.montants[rang].montant
        i += 1
      end
    end
    calcule
  end

  def calcule_rentabilite
    # initialisation
    self.etude_rentabilite.calculees.each do |calculee|
      calculee.montants = nil
      calculee.total = 0
      self.liste_annees.each do |annee|
        calculee.montants << Montant.new(annee: annee,montant: 0)
      end
    end
    self.etude_rentabilite.calculees << Calculee.new(description: "",unite: 'k€')
    self.etude_rentabilite.calculees << Calculee.new(description: "",unite: 'k€')
    self.etude_rentabilite.calculees << Calculee.new(description: "",unite: 'k€')
    self.etude_rentabilite.calculees << Calculee.new(description: "",unite: 'k€')
    self.etude_rentabilite.calculees << Calculee.new(description: "TOTAL FLUX ANNUELS CUMULES actualisés",unite: 'k€')

    # calculees[0] Total Coûts d'investissement initial
    if self.etude_rentabilite.direct && self.etude_rentabilite.direct.calculees[0] then
      # ajouter direct.calculees[0] à rentabilite.calculees[0]
      self.etude_rentabilite.calculees[0] = self.calcul_somme(self.etude_rentabilite.calculees[0],self.etude_rentabilite.direct.calculees[0],'-')
    end
    if self.etude_rentabilite.indirect && self.etude_rentabilite.indirect.calculees[4] then
      # ajouter indirect.calculees[4] à rentabilite.calculees[0]
      self.etude_rentabilite.calculees[0] = self.calcul_somme(self.etude_rentabilite.calculees[0],self.etude_rentabilite.indirect.calculees[4],'-')
    end
    self.cout = -self.etude_rentabilite.calculees[0].total
    # calculees[1] Total Coûts d'investissement initial actualisés
    self.etude_rentabilite.calculees[1] = self.actualise(self.etude_rentabilite.calculees[1],self.etude_rentabilite.calculees[0],'+')
    # calculees[2] Total Impacts Métiers actualisé
    if self.etude_rentabilite.gain && self.etude_rentabilite.gain.calculees[13] then
      self.etude_rentabilite.calculees[2] = self.actualise(self.etude_rentabilite.calculees[2],self.etude_rentabilite.gain.calculees[13],'+')
    end
    # calculees[3] Total Impacts sur les coûts de fonctionnement SI actualisé
    if self.etude_rentabilite.fonction && self.etude_rentabilite.fonction.calculees[0] then
      self.etude_rentabilite.calculees[3] = self.actualise(self.etude_rentabilite.calculees[3],self.etude_rentabilite.fonction.calculees[0],'-')
    end
    # calculees[4] Gains nets (Impacts métiers + Impacts fonctionnement système) 
    if self.etude_rentabilite.gain && self.etude_rentabilite.gain.calculees[13] then
      self.etude_rentabilite.calculees[4] = self.calcul_somme(self.etude_rentabilite.calculees[4],self.etude_rentabilite.gain.calculees[13],'+')
    end
    if self.etude_rentabilite.fonction && self.etude_rentabilite.fonction.calculees[0] then
      self.etude_rentabilite.calculees[4] = self.calcul_somme(self.etude_rentabilite.calculees[4],self.etude_rentabilite.fonction.calculees[0],'-')
    end
    # calculees[5] TOTAL FLUX ANNUELS non actualisés (k€)
    self.etude_rentabilite.calculees[5] = self.calcul_somme(self.etude_rentabilite.calculees[5],self.etude_rentabilite.calculees[0],'+')
    self.etude_rentabilite.calculees[5] = self.calcul_somme(self.etude_rentabilite.calculees[5],self.etude_rentabilite.calculees[4],'+')
    flows = []
    self.etude_rentabilite.calculees[5].montants.each { |mt| flows << mt.montant }
    until flows.empty? || flows[0] < 0  do flows.delete_at(0) end
    until flows.empty? || flows[-1] = 0 do flows.pop end
    if flows.count >= 2 then self.tri = NewtonRaphsonIrrCalculator.calculate(flows,100,0.1)*100 else self.tri = nil end
    # calculees[6] (ajout de 1,2 et 3) TOTAL FLUX ANNUELS actualisés
    self.etude_rentabilite.calculees[6] = self.calcul_somme(self.etude_rentabilite.calculees[6],self.etude_rentabilite.calculees[1],'+')
    self.etude_rentabilite.calculees[6] = self.calcul_somme(self.etude_rentabilite.calculees[6],self.etude_rentabilite.calculees[2],'+')
    self.etude_rentabilite.calculees[6] = self.calcul_somme(self.etude_rentabilite.calculees[6],self.etude_rentabilite.calculees[3],'+')
    self.van = self.etude_rentabilite.calculees[6].total
    if self.van < 0 then
      self.delai_retour = nil
    else
      if self.etude_rentabilite.calculees[6].montants[0].montant >= 0 then 
        self.delai_retour = 0 
      else
        self.delai_retour = 1 - (self.date_debut.month - 1)/12
      end
      (1..self.etude_rentabilite.calculees[6].montants.count - 1).each do |index|
        if self.etude_rentabilite.calculees[6].montants[index-1].montant < 0 then
          if self.etude_rentabilite.calculees[6].montants[index].montant < 0 then
            self.delai_retour += 1
          else
            self.delai_retour -= self.etude_rentabilite.calculees[6].montants[index-1].montant / \
              (self.etude_rentabilite.calculees[6].montants[index].montant - self.etude_rentabilite.calculees[6].montants[index-1].montant)
          end
        end
      end
    end
    # calculees[7] cumuls
    self.etude_rentabilite.calculees[7].montants.each_index do |rang|
      if rang == 0 then
        self.etude_rentabilite.calculees[7].montants[rang].montant = self.etude_rentabilite.calculees[6]
      else
        if self.etude_rentabilite.calculees[6].montants[rang].montant == 0 then
          break
        else
          self.etude_rentabilite.calculees[7].montants[rang].montant = self.etude_rentabilite.calculees[7].montants[rang-1].montant + \
                                                                       self.etude_rentabilite.calculees[6].montants[rang].montant
        end
      end
    end
    # graphique des cumuls
    url = "https://chart.googleapis.com/chart?chs=600x400&chtt=Flux cumulés&cht=lc&chxt=x,y,r&chxl=2:|0&chxp=2,0&chds=a&chd=t:"
    annees = []
    data = []
    self.etude_rentabilite.calculees[7].montants.each { |mt| data << mt.montant.round(0) ; annees << mt.annee }
    while (not data.empty?) && (data[-1] == 0) do
      data.delete_at(-1)
      annees.delete_at(-1)
    end
    data.each { |valeur| url << valeur.to_s << ',' }
    url = url.chop << '&chxl=0:'
    annees.each { |annee| url << '|' << annee.gsub(/\s/,'+') }
    url << '&chxs=1N*s|2,0000dd,0,-1,t,000000&chxtc=0,-5|2,-4000&'
    if data[-1] > 0 then url << 'chco=00FF00&chm=o,00FF00,0,-1,5' else url << 'chco=FF0000&chm=o,FF0000,0,-1,5' end
    self.etude_rentabilite.graphe_flux_cumules = url
    self.etude_rentabilite.a_calculer = false
    self.etude_rentabilite.calculees.each do |calculee|
      calculee.montants.where(montant: 0).destroy_all
      calculee.montants.where(montant: nil).destroy_all
    end
    self.save
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
      if self.projet.resumes.count != 0 && self.projet.resumes[-1].etude_id == self._id
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
  field :duree_vie_totale, type: Float
  field :taux_actu, type: Float, default: 4
  validates :taux_actu, :presence => {:message => "obligatoire"} 
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
  field :van, type: Float
  field :tri, type: Float

  embeds_one :etude_strategie
  embeds_one :etude_rentabilite
end
