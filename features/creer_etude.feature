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
    Quand je clique sur Enregistrer
    Alors l'étude est créée

  Scénario: Si le projet à une série d'étude, les stades possibles sont cohérents
    Quand le projet a déjà une série d'études dont la dernière est au stade :suivi01
    Alors je vois le stade suivi02

  Scénario: La liste des stades permis ne doit pas changer en cas d'erreur après modification
    Etant donné que je ne saisis rien dans la zone etude_code
    Etant donné que je sélectionne "projet" dans la zone Stade
    Quand je clique sur Enregistrer
    Alors je vois le stade avant_projet

  Scénario: Code obligatoire
    Quand je ne saisis rien dans la zone etude_code
    Quand je clique sur Enregistrer
    Alors je vois le message Code obligatoire

  Scénario: Description obligatoire
    Quand je ne saisis rien dans la zone etude_description
    Quand je clique sur Enregistrer
    Alors je vois le message Description obligatoire

  Scénario: Durée du projet obligatoire
    Quand je ne saisis rien dans la zone etude_duree_projet
    Quand je clique sur Enregistrer
    Alors je vois le message Duree projet obligatoire

  Scénario: Durée de vie obligatoire
    Quand je saisis 0 dans la zone etude_duree_vie
    Quand je sélectionne "specifique" dans la zone etude_type_produit
    Alors je vois le message Durée de vie obligatoire
