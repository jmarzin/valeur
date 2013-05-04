# encoding: utf-8
require 'coherence_projet'

class Resume
  include Mongoid::Document
  field :etude_id, type: Integer
  field :date, type: Date
  field :cout, type: Float
  field :duree, type: Float
  field :stade, type: Symbol
  field :note, type: Float
  embedded_in :projet
end

class Projet

  @@wf_etats = {:a_l_etude => [:soumis, :abandonne], :soumis => [:accepte, :refuse], :accepte => [:en_cours, :abandonne], \
    :en_cours => [:arrete, :termine], :arrete => [], :termine => [], :abandonne => [], :refuse => [:a_l_etude, :abandonne]}

  def self.liste_ministeres
    ['Intermin','Aff.Etrangères','Agriculture','Culture','Défense','Ecologie','Finances','Intérieur','Sociaux','Serv. PM']
  end

  def self.liste_quotations
    [nil,0,1,2,3,4,5]
  end

  def liste_etats
    projet_base = Projet.where(_id: self._id).count
    if projet_base == 0
      return [:a_l_edude]
    else
      etat_base = Projet.find(self._id).etat
      if etat_base == :accepte && self.resumes == []
        liste = [:accepte,:abandonne]
      else
        liste = [etat_base]
        @@wf_etats[etat_base].each do |opt| liste <<= opt end
      end
      return liste
    end
  end

  def calcul_derives
    if self.resumes.size < 2 || (self.resumes.size == 2 && self.resumes[0].stade == :avant_projet) then
      self.derive_cout, self.derive_duree = nil, nil
      return self
    end
    base = self.resumes.select{ |resume| resume.stade != :avant_projet }.first
    self.derive_cout = ((self.resumes[-1].cout / base.cout) - 1 ) * 100.round
    self.derive_duree = ((self.resumes[-1].duree / base.duree) - 1 ) * 100.round
    return self
  end

  include Mongoid::Document
  include Mongoid::MultiParameterAttributes
  validates_with(CoherenceProjet)
  field :_id, type:Integer, default: ->{ if Projet.count == 0 then 1 else Projet.last._id + 1 end }
  field :code, type: String
  validates :code, :presence => {:message => "obligatoire"}
  validates :code, :uniqueness => {:message => "doit être unique"}
  field :nom, type: String
  validates :nom, :presence => {:message => "obligatoire"}
  field :ministere, type: String
  validates :ministere, :presence => {:message => "obligatoire"}
  field :public, type: Boolean, default: true
  validates :public, :presence => {:message => "obligatoire"}
  field :etat, type: Symbol, default: :a_l_etude
  validates :etat, :presence => {:message => "obligatoire"}
  validates :etat, :inclusion => { :in => [:a_l_etude,:soumis,:accepte,:en_cours,:termine,:arrete,:abandonne,:refuse],
    :message => "%{value} invalide" }
  field :description, type: String
  validates :description, :presence => {:message => "obligatoire"}
  field :entites_concernees, type: String
  validates :entites_concernees, :presence => {:message => "à préciser"}
  field :date_debut, type: Date
  validates :date_debut, :presence => {:message => "obligatoire pour un projet lancé",
	 :if => "[:en_cours,:arrete,:termine].include?(self.etat)" }
  field :derive_cout, type:Integer
  field :derive_duree, type:Integer
  field :quotation_disic, type:Integer
  validates :quotation_disic, :inclusion => { :in => [nil,0,1,2,3,4,5],
    :message => "%{value} invalide" }
  embeds_many :resumes
  has_many :etudes

end
