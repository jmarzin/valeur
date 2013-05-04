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
    Etant donné que je publie une étude 1 complète au stade projet sur le projet Hélios
    Etant donné une étude complète au stade bilan non publiée sur le projet Hélios
    Quand je suis sur la page /projets/1/etudes/2/edit
    Quand je coche la case Publié
    Quand je saisis la valeur 200 dans le champ etude_cout
    Quand je saisis la valeur 6 dans le champ etude_duree_projet
    Quand je clique sur Enregistrer
    Alors l'étude est ajoutée au résumé du projet
    Et les dérives sont bien calculées

  Scénario: contrôle de la dépublication
    Etant donné le projet Hélios dans la base
    Etant donné que je publie une étude 1 complète au stade projet sur le projet Hélios
    Etant donné une étude complète au stade suivi01 non publiée sur le projet Hélios
    Etant donné que je publie une étude 3 complète au stade suivi01 sur le projet Hélios
    Alors je ne peux pas dépublier l'étude 1

  Scénario: contrôle de la dépublication
    Etant donné le projet Hélios dans la base
    Etant donné que je publie une étude 1 complète au stade projet sur le projet Hélios
    Etant donné que je publie une étude 2 complète au stade suivi01 sur le projet Hélios
    Alors je peux dépublier l'étude 2
    Et l'étude est retirée du résumé du projet
    Et les dérives sont bien recalculées

  Scénario: contrôle des zones
    Etant donné le projet Hélios dans la base
    Etant donné que je publie une étude 1 complète au stade projet sur le projet Hélios
    Quand je suis sur la page /projets/1/etudes/1/edit
    Alors tous les champs sont inaccessibles, sauf publié

  Scénario: contrôle des zones

    Etant donné le projet Hélios dans la base
    Etant donné que je publie une étude 1 complète au stade projet sur le projet Hélios
    Quand je suis sur la page /projets/1/etudes
    Alors le lien Supp est absent sur la ligne de la première

  Scénario: contrôle des zones
    Etant donné le projet Hélios dans la base
    Etant donné que je publie une étude 1 complète au stade projet sur le projet Hélios
    Etant donné que je publie une étude 2 complète au stade suivi01 sur le projet Hélios
    Quand je suis sur la page /projets/1/etudes
    Alors le lien Modif est absent sur la ligne de la première
