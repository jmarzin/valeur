# encoding: utf-8
require 'spec_helper'

describe Etude do
  it "gere_resumes ne met pas à jour les dérives au cas où l'étude est publiée mais le résumé n'est pas vide" do
    @projet = FactoryGirl.create(:projet, code: '1', nom: 'Chorus',resumes: [FactoryGirl.build(:resume)])
    @etude = FactoryGirl.create(:etude, projet_id: @projet._id, code: 'XXXX',stade: :avant_projet, publie: true,\
          date_debut: '2014.01.01',duree_projet: 3.0,type_produit: :front_office,duree_vie: 5,cout: 150.0,delai_retour: 5.4,note: 8.2 )
    @etude.projet.resumes[-1].etude_id = @etude._id
    Projet.should_not_receive(:find)
    @etude.gere_resumes
  end
  it "gere_resumes ne met pas à jour les dérives au cas où l'étude n'est pas publiée et le résumé est vide" do
    @projet = FactoryGirl.create(:projet,code: '1', nom: 'Chorus', resumes: [])
    @etude = FactoryGirl.create(:etude, projet_id: @projet._id, code: 'XXXX',stade: :avant_projet, publie: false,\
          date_debut: '2014.01.01',duree_projet: 3.0,type_produit: :front_office,duree_vie: 5,cout: 150.0,delai_retour: 5.4,note: 8.2 )
    Projet.should_not_receive(:find)
    @etude.gere_resumes 
  end
end
#  def gere_resumes
#    # gestion des résumés
#    if self.publie then
#      if self.projet.resumes.empty? || self.projet.resumes[-1].etude_id != self._id
#        self.projet.resumes.push\
#          (Resume.new(etude_id: self._id,stade: self.stade,date: self.date_publication,cout: self.cout,duree: self.duree_projet,note: self.note))
#      else
#        return
#      end
#    else
#      if not self.projet.resumes.empty? && self.projet.resumes[-1].etude_id = self._id
#        self.projet.resumes.pop
#      else
#        return
#      end
#    end
#    Projet.find(self.projet_id).calcul_derives.save!
#  end
