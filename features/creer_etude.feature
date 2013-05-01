# language: fr

Fonctionnalité: Création d'un scénario
   En tant que gestionnaire de projet
   De façon à faire une étude maréva
   Je veux pouvoir créer un scénario

  Contexte: Remplir les champs du formulaire de création
    Etant donné le projet Chorus dans la base
    Quand je vais sur la page /projets/1/etudes/new
    Et que je saisis les données du formulaire étude

  Scénario: Quand tout est saisi il n'y a pas d'erreur
    Quand je clique sur Save
    Alors l'étude est créée

  Scénario: La liste des stades permis ne doit pas changer en cas d'erreur après modification
    Etant donné que je ne saisis rien dans la zone etude_code
    Etant donné que je sélectionne "projet" dans la zone Stade
    Quand je clique sur Save
    Alors je vois le stade :avant_projet
