# language: fr

Fonctionnalité: Modification des études
  En tant que gestionnaire des études mareva
  De façon à tenir compte des changements
  Je veux pouvoir les modifier

  Scénario: contrôle de la navigation   
    Etant donné le projet Hélios dans la base
    Etant donné une étude complète au stade bilan non publiée sur le projet Hélios
    Quand je suis sur la page /projets
    Quand je suis le lien Etudes
    Quand je suis le lien Modif    
    Alors je me retrouve sur la page /projets/1/etudes/1/edit

  Scénario: contrôle de la zone stade
    Etant donné le projet Hélios dans la base
    Etant donné une étude complète au stade bilan non publiée sur le projet Hélios
    Quand je suis sur la page /projets/1/etudes/1/edit
    Alors le stade est désactivé

  Scénario: contrôle de la publication
    Etant donné le projet Hélios dans la base
    Etant donné une étude complète au stade bilan non publiée sur le projet Hélios
    Quand je suis sur la page /projets/1/etudes/1/edit
    Quand je coche la case Publié
    Et je ne saisis rien dans le champ Coût
    Quand je clique sur Enregistrer
    Alors je vois le message Cout obligatoire

  Scénario: contrôle de la publication
    Etant donné le projet Hélios dans la base
    Etant donné une étude complète au stade bilan non publiée sur le projet Hélios
    Quand je suis sur la page /projets/1/etudes/1/edit
    Quand je coche la case Publié
    Et je ne saisis rien dans le champ Délai retour
    Quand je clique sur Enregistrer
    Alors je vois le message Delai retour obligatoire

  Scénario: contrôle de la publication
    Etant donné le projet Hélios dans la base
    Etant donné une étude complète au stade bilan non publiée sur le projet Hélios
    Quand je suis sur la page /projets/1/etudes/1/edit
    Quand je coche la case Publié
    Et je ne saisis rien dans le champ Note
    Quand je clique sur Enregistrer
    Alors je vois le message Note obligatoire

  Scénario: contrôle de la publication
    Etant donné le projet Hélios dans la base
    Etant donné une étude complète au stade bilan non publiée sur le projet Hélios
    Quand je suis sur la page /projets/1/etudes/1/edit
    Quand je coche la case Publié
    Quand je clique sur Enregistrer
    Alors l'étude est ajoutée au résumé du projet
    Et les dérives sont bien calculées

  Scénario: contrôle de la dépublication
    Etant donné le projet Hélios dans la base
    Etant donné que je publie une étude 1 complète au stade projet sur le projet Hélios
    Etant donné une étude complète au stade suivi01 non publiée sur le projet Hélios
    Etant donné que je publie une étude 3 complète au stade suivi01 sur le projet Hélios
    Alors je ne peux pas dépublier l'étude 1

@en_cours
  Scénario: contrôle de la dépublication
    Etant donné le projet Hélios dans la base
    Etant donné que je publie une étude 1 complète au stade projet sur le projet Hélios
    Alors je peux dépublier l'étude 1
    Et l'étude est retirée du résumé du projet
    Et les dérives sont bien recalculées

  Scénario: contrôle de la publication
    Etant donné le projet Hélios dans la base
    Etant donné une étude au stade bilan non publiée sur le projet Hélios
    Quand je suis sur la page /projets/1/etudes/1/edit
    Quand je coche la case Publié
    Quand je clique sur Enregistrer
    Alors je vois le message 'Pas de publication sans date'
#
  Scénario: contrôle des zones
    Quand l'étude est publiée
    Quand je suis sur la page /projets/1/etudes/2/edit
    Alors tous les champs sont grisés, sauf publié


  Scénario: contrôle des zones
    Quand une étude est publiée
    Quand une nouvelle étude est publiée
    Quand je suis sur la page /projets/1/etudes
    Alors le lien Modif est absent sur la ligne de la première


  Scénario: contrôle de la publication
    Quand je suis sur la page /projets/1/etudes/1
    Quand je coche la case publié
    Quand je clique sur Enregistrer
    Alors je vois le message 'Pas de publication sans date'





  Scénario: contrôle de la publication
    Quand je publie une étude au stade projet
    Alors elle écrase l'historique au niveau du projet


  Scénario: contrôle de la dépublication
    Quand je publie une étude au state suivi02
    Quand je la dépublie
    Alors elle est supprimée de l'historique du projet

    

#  Scénario: gestion de la Quotation
#    Etant donné un projet sans étude dans la base
#    Quand je vais sur la page /projets/1/edit
#    Alors je vois un sélecteur de Quotation

#  Scénario: gestion de l'Etat
#    Etant donné un projet sans étude dans la base
#    Quand je vais sur la page /projets/1/edit
#    Alors je vois un sélecteur d'Etat

#  Plan du scénario: gestion de l'état
#    Etant donné un projet sans étude dans l'état <Etat>
#    Quand je vais sur la page /projets/1/edit
#    Alors je vois cet état <Etat> comme option et les options <Présentes>
#    Et je ne vois pas les options <Absentes>

#  Exemples:
#    |Etat      |Présentes             |Absentes                                                |
#    |a_l_etude |soumis abandonne      |accepte rejete en_cours termine arrete                  |
#    |soumis    |accepte refuse        |abandonne en_cours a_l_etude termine arrete             |
#    |accepte   |abandonne             |soumis refuse en_cours a_l_etude termine arrete         |
#    |refuse    |a_l_etude abandonne   |soumis accepte en_cours termine arrete                  |
#    |abandonne |                      |soumis accepte refuse en_cours a_l_etude termine arrete |

#  Plan du scénario: lancement d'un projet
#    Etant donné un projet avec étude dans l'état <Etat>
#    Quand je vais sur la page /projets/1/edit
#    Alors je vois cet état <Etat> comme option et les options <Options>
#    Et je ne vois pas les options <Absentes>

#  Exemples:
#    |Etat      |Options               |Absentes                                                  |
#    |accepte   |abandonne en_cours    |soumis refuse a_l_etude termine arrete                    |
#    |en_cours  |termine arrete        |soumis abandonne accepte refuse a_l_etude                 |
#    |termine   |                      |soumis abandonne accepte refuse en_cours a_l_etude arrete |
#    |arrete    |                      |soumis abandonne accepte refuse en_cours a_l_etude termine|
      
#  Scénario: La liste des états permis évolue si l'état est modifié
#    Etant donné un projet avec étude dans l'état a_l_etude
#    Etant donné que je suis sur la page /projets/1/edit
#    Etant donné que je sélectionne "soumis" dans la zone Etat
#    Quand je suis le lien Modif
#    Alors je ne vois pas l'option a_l_etude
#    Etant donné que je sélectionne "accepte" dans la zone Etat
#    Quand je suis le lien Modif
#    Alors je ne vois pas l'option soumis

#  Scénario: La liste des états permis ne doit pas changer en cas d'erreur après modification
#    Etant donné un projet avec étude dans l'état a_l_etude
#    Etant donné que je suis sur la page /projets/1/edit
#    Etant donné que je ne saisis rien dans la zone projet_code
#    Etant donné que je sélectionne "soumis" dans la zone Etat
#    Quand je clique sur Enregistrer
#    Alors je vois l'option a_l_etude