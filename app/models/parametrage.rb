# encoding: utf-8
require 'xmlsimple'

class PReponse
  include Mongoid::Document
  embedded_in :p_axis
  field :texte, type: String
  field :justification, type: String
  field :cle_sectionnee, type: String
  field :note, type: Float 
  field :appreciation, type: Hash
end

class PAxis
  include Mongoid::Document
  embedded_in :p_category
  field :nom, type: String
  field :note, type: Float
  field :appreciation, type: Hash
  embeds_many :p_reponses
end

class PCategory
  include Mongoid::Document
  embedded_in :p_domaine
  field :nom, type: String
  field :note, type: Float
  field :appreciation, type: Hash
  embeds_many :p_axes
end

class PDomaine
  include Mongoid::Document
  embedded_in :p_strategie
  field :nom, type: String
  field :note_ponderee, type: Float
  field :cle_selectionnee, type: String
  field :ponderation, type: Hash
  embeds_many :p_categories
end

class PStrategie
  include Mongoid::Document
  embedded_in :parametrage
  embeds_many :p_domaines
end

class Parametrage

  def self.lit_feuille(tableau,domaine)
    dans_parametre = false
    dans_categorie = false
    dans_axes = false
    tableau.each do |ligne|
      if dans_parametre
        if dans_categorie
          if dans_axes
            if ligne[1] =~ /\d00/ && ligne[2]
              @axe = PAxis.new(nom: ligne[2], appreciation: {})
              (4..7).each {|i| if ligne[i] != '' then @axe.appreciation[ligne[i]] = nil end}
            elsif ligne[2] == "Seuils d'attribution de la note" && ligne[4]
              col = 4
              @axe.appreciation.keys.each { |cle| @axe.appreciation[cle] = ligne[col].to_f ; col += 1 }
              @categorie.p_axes << @axe
            elsif ligne[1] =~ /\d\d\d/ && ligne[2]
              @reponse = PReponse.new(texte: ligne[2], appreciation: {})
              (4..7).each {|i| if ligne[i] != '' then @reponse.appreciation[ligne[i]] = ligne[i+5].to_f end}
              @axe.p_reponses << @reponse
            end
          else
            if ligne[2] == "Seuils d'attribution de la note" && ligne[4]
              dans_axes = true
              col = 4
              @categorie.appreciation.keys.each { |cle| @categorie.appreciation[cle] = ligne[col].to_f ; col += 1 }
              domaine.p_categories << @categorie
            end
          end
        else
          if ligne[1] =='0'
            dans_categorie = true
            @categorie = PCategory.new(nom: ligne[2],appreciation: {})
            (4..7).each {|i| if ligne[i] != '' then @categorie.appreciation[ligne[i]] = nil end}
            dans_axes = false
          end
        end
      else
        if ligne[1] =~ /PARAMETRES A COMPLETER/
          dans_parametre = true
          dans_categorie = false
        end
      end
    end
    domaine
  end

  def self.lit_ponderation(tableau,parametrage)
    parametrage
  end

  def self.transforme(reduit)
    @parametrage = Parametrage.create(ministere: 'Intermin',code: 'Standard',description: 'Original',publie: true,date_publication: '2013.05.11')
    @parametrage.create_p_strategie
    @parametrage.p_strategie.p_domaines << PDomaine.new(nom: 'Valeur métier')
    @metier = @parametrage.p_strategie.p_domaines.where(nom: 'Valeur métier').first
    @parametrage.p_strategie.p_domaines << PDomaine.new(nom: 'Valeur dsi')
    @dsi = @parametrage.p_strategie.p_domaines.where(nom: 'Valeur dsi').first
    reduit.each do |onglet,tableau|
      if ['Admin Image','Admin Apports','Admin valeur metier'].include?(onglet)
        @metier = Parametrage.lit_feuille(tableau,@metier)
      elsif onglet == 'Admin valeur SI'
        @dsi = Parametrage.lit_feuille(tableau,@dsi)
      else
        @parametrage = Parametrage.lit_ponderation(tableau,@parametrage)
      end
    end
    binding.pry       
  end

  def self.charge_xml(fichier)
    x_lu = XmlSimple.xml_in(fichier)
    @reduit={}
    x_lu.each do |cle,tab1| 
      if cle == 'Worksheet'
        tab1.each do |hash1|
          if ['Admin Image','Admin Apports','Admin valeur metier','Admin valeur SI','Synthèse'].include?(hash1['ss:Name'])
            onglet = hash1['ss:Name']
            @reduit[onglet] = []
            hash1['Table'][0]['Row'].each_index do |i|
              @reduit[onglet][i] = []
              if hash1['Table'][0]['Row'][i]['Cell']
                hash1['Table'][0]['Row'][i]["Cell"].each_index do |j|
                  if hash1['Table'][0]['Row'][i]['Cell'][j]['Data']
                    @reduit[onglet][i][j] = hash1['Table'][0]['Row'][i]['Cell'][j]['Data'][0]['content']
                  else
                    @reduit[onglet][i][j] = nil
                  end
                end
              end
            end
          end
        end
      end
    end
    @reduit
  end
  include Mongoid::Document
  field :ministere, type: String
  field :code, type: String
  field :description, type: String
  field :publie, type: Boolean
  field :date_publication, type: Date
  embeds_one :p_strategie
end
