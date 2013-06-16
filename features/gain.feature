# language: fr

Fonctionnalité: saisie et modification des gains métier

  Scénario: Atteinte par l'écran d'étude de rentabilité
    Etant donné le projet Hélios dans la base
    Etant donné une étude complète au stade bilan non publiée sur le projet Hélios
    Etant donné que je suis sur la page /projets/1/etudes/1
    Quand je suis le lien Rentabilité
    Alors je me retrouve sur la page /rentabilites/1
    Et je vois le lien 0 dans la zone td#gain

  Scénario: Atteinte de l'écran de consultation des gains métier
    Etant donné le projet Hélios dans la base
    Etant donné une étude complète au stade bilan non publiée sur le projet Hélios
    Etant donné que je suis sur la page /rentabilites/1
    Quand dans la zone td#gain je suis le lien 0
    Alors je me retrouve sur la page /gains/1
    Et je vois le texte Commentaires
    Et je vois le lien Modif dans la zone header

  Scénario: Atteinte de l'écran de modification des gains métier
    Etant donné le projet Hélios dans la base
    Etant donné une étude complète au stade bilan non publiée sur le projet Hélios
    Etant donné que je suis sur la page /gains/1
    Quand dans la zone header je suis le lien Modif
    Alors je me retrouve sur la page /gains/1/edit
    Alors je vois 1 tableau de répartition des cadres d'emplois 
    Et je vois 1 tableau des coûts détaillés

  Scénario: Gestion des erreurs de répartition des catégories de personnel
    Etant donné le projet Hélios dans la base
    Etant donné une étude complète au stade bilan non publiée sur le projet Hélios
    Etant donné que je suis sur la page /gains/1/edit
    Quand je saisis 80 pour les cadres A et 10 pour les cadres B pour ETP1
    Quand je saisis 110 pour les cadres A+ pour ETP5
    Quand dans la zone header je clique sur Actualiser
    Alors je vois le texte La somme des contributions des catégories n'est pas égale à 100 pour le modèle ETP1
    Et je vois le texte La somme des contributions des catégories n'est pas égale à 100 pour le modèle ETP5
@en_cours
  Scénario: Remplissage de l'écran des gains et calcul des totaux
    Etant donné le projet Hélios dans la base
    Etant donné une étude complète au stade bilan non publiée sur le projet Hélios
    Etant donné que je suis sur la page /gains/1/edit
    Quand je remplis le tableau des gains métier
    Quand dans la zone header je clique sur Actualiser
    Alors je vois les cumuls gains calculés

  Scénario: Saisie de commentaires et validation de la saisie
    Etant donné le projet Hélios dans la base
    Etant donné une étude complète au stade bilan non publiée sur le projet Hélios
    Etant donné que je suis sur la page /fonctions/1/edit
    Quand je remplis le tableau des impacts sur les coûts de fonctionnement
    Quand je saisis un commentaire pour la situation actuelle
    Quand je saisis un commentaire pour la situation cible
    Quand dans la zone header je clique sur Enregistrer
    Alors je me retrouve sur la page /fonctions/1
    Et je vois les commentaires au bon endroit