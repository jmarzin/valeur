# language: fr

Fonctionnalité: Création d'un projet
   En tant que gestionnaire de projet
   De façon à préparer son instruction
   Je veux pouvoir créer un projet

   Contexte: Remplir les champs du formulaire de création
     Etant donné que je suis sur la page de création d'un projet
     Et que je saisis les donnees du formulaire

   Scénario: Quand tout est saisi, il n'y a pas d'erreur
     Alors je ne vois pas d'erreur

   Scénario: Quand tout est saisi, je peux valider
     Quand je clique sur Save
     Alors je me retrouve sur la page /projets/1
     Et je vois mon projet

   Scénario: Créer un projet, code obligatoire
     Quand je ne saisis rien dans la zone code
     Alors je vois le message Code obligatoire

   Scénario: Créer un projet, nom obligatoire
     Quand je ne saisis rien dans la zone nom
     Alors je vois le message Nom obligatoire

  Scénario: Créer un projet, description obligatoire
     Quand je ne saisis rien dans la zone description
     Alors je vois le message Description obligatoire

   Scénario: Créer un projet, entités concernées obligatoire
     Quand je ne saisis rien dans la zone entites_concernees
     Alors je vois le message Entites concernees à préciser
	
