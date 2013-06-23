# encoding: utf-8
class CoherenceProjet < ActiveModel::Validator
  def validate(rec)
    if rec.class == Projet then
      if [:en_cours,:termine,:arrete].include?(rec.etat) && rec.resumes.empty?
        rec.errors[:base] << "Un projet lancé doit avoir au moins un résumé d'étude"
      end
      rec.resumes.each do |r|
        rec.errors[:base] << "Chaque résumé doit être complet" unless r.date && r.cout && r.duree
      end
      nb = 0
      rec.resumes.each do |e| nb += 1 end 
      if nb <= 1 || (nb == 2 && rec.resumes[0].stade == :avant_projet) 
        if rec.derive_cout
          rec.errors[:base] << "Le calcul de la dérive des coûts nécessite 2 vraies études"
        end
        if rec.derive_duree
          rec.errors[:base] << "Le calcul de la dérive de la durée nécessite 2 vraies études"
        end
      else 
        if not rec.derive_cout
          rec.errors[:base] << "La dérive des coûts est calculée s'il y a plusieurs vraies études"
        end
        if not rec.derive_duree
          rec.errors[:base] << "La dérive de la durée est calculée s'il y a plusieurs vraies études"
        end
      end
    elsif rec.class == Etude 
      if rec.publie and not Etude.where(projet_id: rec.projet_id,stade: rec.stade, publie: true).empty?
        rec.errors[:base] << "Doublon de publication"
      end
      if not rec.publie then
        rec.date_publication = nil
      end
      rec.errors[:base] << rec.stade.to_s+" invalide" \
        unless rec.stade.to_s =~ /^(suivi\d\d|avant_projet|projet|bilan)$/
      if rec.type_produit == :specifique && (rec.duree_vie == nil || rec.duree_vie == 0)
        rec.errors[:base] << "Durée de vie obligatoire"
      else
        rec.duree_vie = Etude.val_type_produit[rec.type_produit] if rec.type_produit != :specifique
      end
    elsif rec.class == Indirect
      if rec.somme_pourcent != 100
        rec.errors[:base] << "La somme des contributions des catégories n'est pas égale à 100"
      end
    elsif rec.class == Situation
      if rec.somme_pourcent != 100
        rec.errors[:base] << "La somme des contributions des catégories n'est pas égale à 100 pour la situation "+rec.titre
      end
    elsif rec.class == EtpRepart
      if rec.somme_pourcent != 100
        rec.errors[:base] << "La somme des contributions des catégories n'est pas égale à 100 pour le modèle "+rec.titre
      end
    end
  end
end
