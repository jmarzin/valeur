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

  Scénario: / renvoie vers la page projets
    Quand je vais sur la page /
    Alors je me retrouve sur la page /projets