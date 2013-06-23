# language: fr

Fonctionnalité: saisie et modification des coûts d'investissement directs

  Scénario: Atteinte par l'écran d'étude de rentabilité
    Etant donné le projet Hélios dans la base
    Etant donné une étude complète au stade bilan non publiée sur le projet Hélios
    Etant donné que je suis sur la page /projets/1/etudes/1
    Quand je suis le lien Rentabilité
    Alors je me retrouve sur la page /rentabilites/1
    Et je vois le lien 0 dans la zone td#direct

  Scénario: Atteinte de l'écran de consultation des coûts d'investissements directs
    Etant donné le projet Hélios dans la base
    Etant donné une étude complète au stade bilan non publiée sur le projet Hélios
    Etant donné que je suis sur la page /rentabilites/1
    Quand dans la zone td#direct je suis le lien 0
    Alors je me retrouve sur la page /directs/1
    Et je vois le texte Commentaires
    Et je vois le lien Modif dans la zone header

  Scénario: Atteinte de l'écran de modification des coûts d'investissements directs
    Etant donné le projet Hélios dans la base
    Etant donné une étude complète au stade bilan non publiée sur le projet Hélios
    Etant donné que je suis sur la page /directs/1
    Quand dans la zone header je suis le lien Modif
    Alors je me retrouve sur la page /directs/1/edit
    Et je vois le tableau des coûts détaillés
    Et je vois le tableau des coûts cumulés par nature

  Scénario: Remplissage de l'écran et calcul des totaux
    Etant donné le projet Hélios dans la base
    Etant donné une étude complète au stade bilan non publiée sur le projet Hélios
    Etant donné que je suis sur la page /directs/1/edit
    Quand je remplis le tableau des coûts détaillés
    Quand dans la zone header je clique sur Actualiser
    Alors je vois les cumuls calculés

  Scénario: Saisie d'un commentaire et validation de la saisie
    Etant donné le projet Hélios dans la base
    Etant donné une étude complète au stade bilan non publiée sur le projet Hélios
    Etant donné que je suis sur la page /directs/1/edit
    Quand je remplis le tableau des coûts détaillés
    Quand je saisis un commentaire sur les coûts directs
    Quand dans la zone header je clique sur Enregistrer
    Alors je me retrouve sur la page /directs/1
    Et je vois le commentaire sur les coûts directs

  Scénario: Remplissage de l'écran et génération de la synthèse
    Etant donné le projet Hélios dans la base
    Etant donné une étude complète au stade bilan non publiée sur le projet Hélios
    Etant donné que je suis sur la page /directs/1/edit
    Quand je remplis le tableau des coûts détaillés
    Quand dans la zone header je clique sur Enregistrer
    Quand dans la zone header je suis le lien Rentabilité
    Alors je vois la synthèse des coûts directs
