# language: fr

Fonctionnalité: Consultation des projets
  En tant que citoyen
  De façon à me renseigner sur les projets de l'Etat
  Je veux pouvoir les consulter

   Scénario: Consulter la liste des projets
     Quand je suis sur la page projets
     Alors je vois Code,Nom,Ministère,Public,Etat,Date début,Montant,Retour,Delta coût,Delta dr,Quotation

   Scénario: Consulter les données des projets
     Etant donné un projet complet dans la base
     Quand je suis sur la page projets
     Alors je vois ses Code,Nom,Ministère,Public,Etat,Date début,Montant,Retour,Delta coût,Delta dr,Quotation

#  Scénario: Consulter la liste des projets
#    Etant donné les projets suivants:
#    |nom    |ministere  |etat       |date_de_debut |date       |montant |dr  |
#    |Chorus |Finances   |:lance     |01.01.2013    |01.01.2013 |1000    |6.2 |
#    |Hélios |Finances   |:a_l_etude |02.02.2013    |           |        |    |
#    |Sirenh |Education  |:a_l_etude |03.03.2013    |           |        |    |
#    Quand je suis sur la page projets
#    Alors je vois le code, le nom, le ministère, l'état, la date de début, le montant, le délai de retour et la quotation disic#

#  Scénario: Register new projet
#    Etant donné I am on the new projet page
#    Et I press "Create"
#
#  Scénario: Delete projet
#    Etant donnés the following projets:
#      ||
#      ||
#      ||
#      ||
#      ||
#    Quand I delete the 3rd projet
#    Alors I should see the following projets:
#      ||
#      ||
#      ||
#      ||
