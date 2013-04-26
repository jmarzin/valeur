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
     Alors je me retrouve sur la page projets
     Et je vois mon projet

   Scénario: Créer un projet, code obligatoire
     Quand je ne saisis rien dans la zone code
     Alors je vois le message Code obligatoire

   Scénario: Créer un projet, nom obligatoire
     Quand je ne saisis rien dans la zone nom
     Alors je vois le message Nom obligatoire

   Scénario: Créer un projet, ministère obligatoire
     Quand je ne saisis rien dans la zone ministere
     Alors je vois le message Ministere obligatoire

   Scénario: Créer un projet, description obligatoire
     Quand je ne saisis rien dans la zone description
     Alors je vois le message Description obligatoire

   Scénario: Créer un projet, entités concernées obligatoire
     Quand je ne saisis rien dans la zone entites_concernees
     Alors je vois le message Entites concernees à préciser

   Scénario: Créer un projet, type de produit invalide
     Quand je ne saisis rien dans la zone type_de_produit
     Alors je vois le message Type de produit invalide

   Scénario: Créer un projet, durée de vie obligatoire
     Quand je ne saisis rien dans la zone duree_de_vie
     Alors je vois le message Duree de vie obligatoire

   Scénario: Créer un projet, quotation disic obligatoire
     Quand je ne saisis rien dans la zone quotation_disic
     Alors je vois le message Quotation disic invalide

	
