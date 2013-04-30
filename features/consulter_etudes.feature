# language: fr

Fonctionnalité: Consultation des études d'un projet
  En tant que DSI
  De façon à suivre les scénarios des études mareva
  Je veux pouvoir les consulter

  Contexte: Deux projets, Chorus et Hélios
    Etant donné un projet Chorus et un projet Hélios
    Etant donné une étude sur le seul projet Hélios

  Scénario: pour consulter les études, je passe par la liste des projets
    Etant donné que je suis sur la page projets
    Quand je clique le lien Etudes de la ligne Hélios
    Alors je me retrouve sur la page /projets/2/etudes
    Et je vois Liste des études du projet Hélios

  Scénario: s'il n'y a pas d'étude
    Quand il n'y a pas d'étude pour le projet Chorus
    Quand je suis sur la page des études du projet
    Alors je vois Liste des études du projet Chorus
    Et je ne vois pas la ligne d'entête
 
  Scénario: Consulter la liste des études
    Quand il y a une étude pour le projet Chorus
    Quand je suis sur la page études du projet
    Alors je vois la ligne d'entête

  Scénario: Consulter les données des études
    Quand il y a une étude pour le projet Chorus
    Quand je suis sur la page études du projet
    Alors je vois ses données
