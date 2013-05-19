# -*- coding: utf-8 -*-
require 'spec_helper'
require 'pry'

describe Parametrage do
  describe "Transformation d'un fichier parametrages en fichier parametres" do
    #seuils_standard = { "D" => 0, "C" => 9, "B" => 13, "A" => 16 }
    #ponderations_standard = {"Forte" => 2, "Normale" => 1, "Faible" => 0.5, "Ignorer" => 0}
    #param = Parametrage.first
    #nouveau = Parametre.create(ministere: param.ministere,code: param.code,description: param.description,\
    #  publie: param.publie,date_publication: param.date_publication)
    #nouveau.param_strategie = ParamStrategie.new
    #nouveau.param_strategie.param_groupes << ParamGroupe.new(nom: "Appréciation globale",seuils: seuils_standard)
    #niveau = []
    #niveau[0] = nouveau.param_strategie.param_groupes[0]
    #param.p_strategie.p_domaines.each do |domaine|
    #  niveau[0].param_groupes << ParamGroupe.new(nom: domaine.nom,seuils: seuils_standard, prise_en_compte: "Normale",ponderations: ponderations_standard)
    #  niveau[1] = niveau[0].param_groupes[-1]
    #  domaine.p_categories.each do |categorie|
    #    niveau[1].param_groupes << ParamGroupe.new(nom: categorie.nom,seuils: categorie.seuils,prise_en_compte: "Normale",\
    #      ponderations: ponderations_standard)
    #    niveau[2] = niveau[1].param_groupes[-1]
    #    if categorie.p_reponses && categorie.p_reponses != []
    #      categorie.p_reponses.each do |reponse|
    #        niveau[2].param_reponses << ParamReponse.new(texte: reponse.texte,choix: reponse.choix,options: reponse.options)
    #      end
    #    else
    #      categorie.p_axes.each do |axe|
    #        binding.pry
    #        niveau[2].param_groupes << ParamGroupe.new(nom: axe.nom,seuils: axe.seuils,prise_en_compte: "Normale",ponderations: ponderations_standard)
    #        niveau[3] = niveau[2].param_groupes[-1]
    #        if axe.p_reponses
    #          axe.p_reponses.each do |reponse|
    #            niveau[3].param_reponses << ParamReponse.new(texte: reponse.texte,choix: reponse.choix,options: reponse.options)
    #          end
    #        end
    #      end
    #    end
    #  end
    #end
  end
  describe "Lecture d'un fichier xml" do
  #  it "charge un fichier xml" do
  #    @reduit = Parametrage.charge_xml('/home/jacques/Bureau/S.xml')
  #    Parametrage.transforme(@reduit)
  #    binding.pry     
  #    pending
  #  end
  #  it "modifie la structure du paramétrage" do
  #    param = Parametrage.where(code: 'Standard').first
  #    param.p_strategie.p_domaines.each do |dom|
  #      dom.p_categories.each do |cat|
  #        if cat.p_reponses == [] then
  #          cat.p_axes.each do |axe|
  #            if axe.p_reponses == [] then
  #            else
  #              axe.p_reponses.each do |rep| 
  #                rep.choix = '<Choisir une option>'
  #                rep.appreciation= Hash[rep.appreciation.to_a.unshift([rep.choix,nil])]
  #              end
  #            end
  #          end
  #        else
  #          cat.p_reponses.each do |rep|
  #            rep.choix = '<Choisir une option>'
  #            rep.appreciation= Hash[rep.appreciation.to_a.unshift([rep.choix,nil])]
  #          end
  #        end
  #      end
  #    end
  #  end
  end
end

