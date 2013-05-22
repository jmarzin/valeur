# language: fr

Fonctionnalité: Consultation du volet stratégie d'une étude
  En tant que gestionnaire de projet
  Je dois pouvoir consulter et modifier le volet stratégie d'une étude

  Scénario: Accès à l'écran de consultation du volet stratégie
    Etant donné le projet Hélios dans la base
    Etant donné une étude complète au stade bilan non publiée sur le projet Hélios
    Etant donné que je suis sur la page /projets/1/etudes/1
    Quand je suis le lien Stratégie
    Alors je me retrouve sur la page /strategies/1
    Et je vois la question Ce projet est-il d'une haute complexité fonctionnelle

  Scénario: Accès à l'écran de modification du volet stratégie
    Etant donné le projet Hélios dans la base
    Etant donné une étude complète au stade bilan non publiée sur le projet Hélios
    Etant donné que je suis sur la page /strategies/1
    Quand je suis le premier lien Modif
    Alors je me retrouve sur la page /strategies/1/edit
    Et je vois le texte Modification du volet Stratégie de l'étude 1 du projet Hélios

  Scénario: Modification et sauvegarde d'une stratégie
    Etant donné le projet Hélios dans la base
    Etant donné une étude complète au stade bilan non publiée sur le projet Hélios
    Etant donné que je suis sur la page /strategies/1/edit
    Quand je sélectionne les valeurs:
      |significatifs|
      |significatif |
      |gain de temps|
      |gain d'argent|
      |oui          |
      |gain de temps|
      |gain d'argent|
      |oui          |
      |oui          |
      |oui, très significativement|
      |oui          |
      |oui très significativement|
      |N/A          |
      |N/A          |
      |oui          |
      |oui          |
      |N/A          |
      |moyen        |
      |oui très significativement|
      |non          |
      |oui          |
      |oui très significativement|
      |oui          |
      |oui, négatifs|
      |oui          |
      |oui          |
      |oui          |
      |oui          |
      |oui          |
      |oui          |
      |oui          |
      |oui          |
      |oui          |
      |oui          |
      |oui          |
      |oui          |
      |oui          |
      |oui          |
      |oui          |
      |oui          |
      |non          |
      |oui très significativement|
      |N/A          |
      |oui projet indispensable|
      |oui très significativement|
      |oui très significativement|
      |non          |
      |oui          |
      |oui          |
      |oui, très significativement|
      |oui          |
      |oui, très significativement|
      |N/A          |
      |non          |    
    Quand je clique le premier bouton Enregistrer
    Alors je vois les bons résultats calculés
