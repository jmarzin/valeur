# encoding: utf-8
class CoherenceProjet < ActiveModel::Validator
  def validate(rec)
    if rec.class == Projet then
      if [:lance,:termine,:arrete].include?(rec.etat) && rec.resumes.empty?
        rec.errors[:base] << "Un projet lancé doit avoir au moins un résumé d'étude"
      end
      rec.resumes.each do |r|
        rec.errors[:base] << "Chaque résumé doit être complet" unless r.date && r.cout && r.delai
      end
      nb = 0
      rec.resumes.each do |e| nb += 1 end 
      if nb <= 1
        if rec.derive_cout
          rec.errors[:base] << "Le calcul de la dérive des coûts nécessite 2 études"
        end
        if rec.derive_delai
          rec.errors[:base] << "Le calcul de la dérive du délai de retour nécessite 2 études"
        end
      else 
        if not rec.derive_cout
          rec.errors[:base] << "La dérive des coûts est calculée s'il y a plusieurs études"
        end
        if not rec.derive_delai
          rec.errors[:base] << "La dérive du délai de retour est calculée s'il y a plusieurs études"
        end
      end
    else
      if rec.publie and not Etude.where(projet_id: rec.projet_id,stade: rec.stade, publie: true).empty?
        rec.errors[:base] << "Doublon de publication"
      end
      if not rec.publie
        if not rec.date_publication == nil
           rec.errors[:base] << "Pas de date de publication sans publier"
        end
      elsif rec.date_publication == nil
          rec.errors[:date_publication] << "Date de publication obligatoire"
      end
      rec.errors[:base] << rec.stade.to_s+" invalide" \
        unless rec.stade.to_s =~ /^(suivi\d\d|avant_projet|projet|bilan)$/
    end      
  end
end
