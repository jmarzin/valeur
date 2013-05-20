# encoding: utf-8
require 'xmlsimple'

class ParamReponse
  include Mongoid::Document
  embedded_in :ParamGroupe
  field :texte, type: String
  field :options, type: Hash
end

class ParamGroupe
  include Mongoid::Document
  embedded_in :param_strategie
  embedded_in :param_groupe
  field :nom, type: String
  field :seuils, type: Hash
  field :prise_en_compte, type: String
  field :ponderations, type: Hash
  embeds_many :param_groupes
  embeds_many :param_reponses
end

class ParamStrategie
  include Mongoid::Document
  embedded_in :parametrage
  embeds_many :param_groupes
end

class Parametrage
  include Mongoid::Document
  field :ministere, type: String
  field :code, type: String
  field :description, type: String
  field :publie, type: Boolean
  field :date_publication, type: Date
  embeds_one :param_strategie
end
