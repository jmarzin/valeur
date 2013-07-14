# language: fr

Fonctionnalité: Copie d'une étude
  En tant que gestionnaire des études mareva
  De façon à pouvoir décrire des variantes
  Je veux pouvoir partir d'une étude déjà faite

  Scénario: copie d'une étude  
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
    Etant donné que je suis sur la page /directs/1/edit
    Quand je remplis le tableau des coûts détaillés
    Quand dans la zone header je clique sur Enregistrer
    Etant donné que je suis sur la page /indirects/1/edit
    Quand je remplis le tableau des coûts indirects détaillés
    Quand je saisis un commentaire sur les coûts indirects
    Quand dans la zone header je clique sur Enregistrer
    Etant donné que je suis sur la page /fonctions/1/edit
    Quand je remplis le tableau des impacts sur les coûts de fonctionnement
    Quand je saisis un commentaire pour la situation actuelle
    Quand je saisis un commentaire pour la situation cible
    Quand dans la zone header je clique sur Enregistrer
    Etant donné que je suis sur la page /gains/1/edit
    Quand je remplis le tableau des gains métier
    Quand dans la zone header je clique sur Enregistrer
    Quand dans la zone header je suis le lien Rentabilité
    Etant donné que je suis sur la page /projets/1/etudes
    Quand je suis le lien Copie
    Alors j'ai créé une copie de l'étude 1