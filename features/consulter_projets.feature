# language: fr

Fonctionnalité: Consultation des projets
  En tant que citoyen
  De façon à me renseigner sur les projets de l'Etat
  Je veux pouvoir les consulter

  Scénario: s'il n'y a pas de projet
    Quand il n'y pas de projet
    Quand je suis sur la page /projets
    Alors je ne vois pas Id,Code,Nom,Ministère,Public,Etat,Date début,Montant,Durée,Delta coût,Delta durée,Quotation
 
  Scénario: Consulter la liste des projets
    Etant donné un projet complet dans la base
    Quand je suis sur la page /projets
    Alors je vois Id,Code,Nom,Ministère,Public,Etat,Date début,Montant,Durée,Delta coût,Delta durée,Quotation

  Scénario: Consulter les données des projets
    Etant donné un projet complet dans la base
    Quand je suis sur la page /projets
    Alors je vois ses Id,Code,Nom,Ministère,Public,Etat,Date début,Montant,Durée,Delta coût,Delta durée,Quotation
    Et je vois son historique

  Scénario: / renvoie vers la page projets
    Quand je vais sur la page /
    Alors je me retrouve sur la page /projets

  Scénario: Seul un projet abandonne peut être supprimé
    Etant donnés des projets des différents états dans la base
    Alors je vois le lien Supp pour le projet Abandonné
    Et je ne vois pas le lien Supp pour les autres

  Scénario: Les projets aux stades finaux ne peuvent être modifiés
    Etant donnés des projets des différents états dans la base
    Alors je ne vois pas le lien Modif pour les projets Abandonné, Terminé, Arrêté
    Et je vois le lien Modif pour les autres

