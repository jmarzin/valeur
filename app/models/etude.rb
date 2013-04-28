class Etude
  include Mongoid::Document
  field :stade, type: String
  field :code, type: String
  field :description, type: String
  field :type_produit, type: String
  field :date_debut, type: String
  field :date_publication, type: Date
  field :duree_projet, type: String
  field :duree_vie, type: Integer
  field :publie, type: Boolean
  field :cout, type: String
  field :delai_retour, type: Float
  belongs_to :projet
end
