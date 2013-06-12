# language: fr

Fonctionnalité: saisie et modification des impacts sur les coûts de fonctionnement

  Scénario: Atteinte par l'écran d'étude de rentabilité
    Etant donné le projet Hélios dans la base
    Etant donné une étude complète au stade bilan non publiée sur le projet Hélios
    Etant donné que je suis sur la page /projets/1/etudes/1
    Quand je suis le lien Rentabilité
    Alors je me retrouve sur la page /rentabilites/1
    Et je vois le lien 0 dans la zone td#fonction

  Scénario: Atteinte de l'écran de consultation des impacts sur les coûts de fonctionnement
    Etant donné le projet Hélios dans la base
    Etant donné une étude complète au stade bilan non publiée sur le projet Hélios
    Etant donné que je suis sur la page /rentabilites/1
    Quand dans la zone td#fonction je suis le lien 0
    Alors je me retrouve sur la page /fonctions/1
    Et je vois le texte Commentaires
    Et je vois le lien Modif dans la zone header

  Scénario: Atteinte de l'écran de modification des impacts sur les coûts de fonctionnement
    Etant donné le projet Hélios dans la base
    Etant donné une étude complète au stade bilan non publiée sur le projet Hélios
    Etant donné que je suis sur la page /fonctions/1
    Quand dans la zone header je suis le lien Modif
    Alors je me retrouve sur la page /fonctions/1/edit
    Alors je vois deux tableaux de répartition des cadres d'emplois 
    Et je vois deux tableaux des impacts détaillés

  Scénario: Gestion d'une erreur de répartition des catégories de personnel situation actuelle
    Etant donné le projet Hélios dans la base
    Etant donné une étude complète au stade bilan non publiée sur le projet Hélios
    Etant donné que je suis sur la page /fonctions/1/edit
    Quand je saisis 80 pour les cadres A et 10 pour les cadres B dans la situation actuelle
    Quand dans la zone header je clique sur Actualiser
    Alors je vois le texte La somme des contributions des catégories n'est pas égale à 100 pour la situation actuelle
@en_cours
  Scénario: Gestion d'une erreur de répartition des catégories de personnel situation cible
    Etant donné le projet Hélios dans la base
    Etant donné une étude complète au stade bilan non publiée sur le projet Hélios
    Etant donné que je suis sur la page /fonctions/1/edit
    Quand je saisis 80 pour les cadres A et 10 pour les cadres B dans la situation cible
    Quand dans la zone header je clique sur Actualiser
    Alors je vois le texte La somme des contributions des catégories n'est pas égale à 100 pour la situation cible

  Scénario: Remplissage de l'écran et calcul des totaux
    Etant donné le projet Hélios dans la base
    Etant donné une étude complète au stade bilan non publiée sur le projet Hélios
    Etant donné que je suis sur la page /indirects/1/edit
    Quand je remplis le tableau des coûts indirects détaillés
    Quand dans la zone header je clique sur Actualiser
    Alors je vois les cumuls indirects calculés

  Scénario: Saisie d'un commentaire et validation de la saisie
    Etant donné le projet Hélios dans la base
    Etant donné une étude complète au stade bilan non publiée sur le projet Hélios
    Etant donné que je suis sur la page /indirects/1/edit
    Quand je remplis le tableau des coûts indirects détaillés
    Quand je saisis un commentaire pour la formation:temps formateur
    Quand dans la zone header je clique sur Enregistrer
    Alors je me retrouve sur la page /indirects/1
    Et je vois le commentaire au bon endroit formation:temps formateur