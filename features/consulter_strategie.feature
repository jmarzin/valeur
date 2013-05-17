# language: fr

Fonctionnalité: Consultation du volet stratégie d'une étude
  En tant que gestionnaire de projet
  Je dois pouvoir consulter le volet stratégie d'une étude
@en_cours
  Scénario: Accès à l'écran de consultation du volet stratégie
    Etant donné le projet Hélios dans la base
    Etant donné une étude complète au stade bilan non publiée sur le projet Hélios
    Etant donné que je suis sur la page /projets/1/etudes/1
    Quand je suis le lien Stratégie
    Alors je me retrouve sur la page /strategies/1
    Et je vois la question Ce projet est-il d'une haute complexité fonctionnelle