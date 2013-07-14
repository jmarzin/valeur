# language: fr

Fonctionnalité: Calcul des paramètres d'un projet rentable
  En tant que gestionnaire de projet
  Je dois pouvoir consulter les caractéristiques d'un projet rentable

  Scénario: Calcul de la VAN, du TRI, du délai de retour, et du graphique
    Etant donné le projet Hélios dans la base
    Etant donné une étude complète au stade bilan non publiée sur le projet Hélios
    Etant donné que je suis sur la page /directs/1/edit
    Quand je saisis un coût direct de 1000 k€ pour la première année
    Quand dans la zone header je clique sur Enregistrer
    Etant donné que je suis sur la page /gains/1/edit
    Quand je saisis le gain autres de 250 k€ par an sur les 10 années qui suivent
    Quand dans la zone header je clique sur Enregistrer
    Quand dans la zone header je suis le lien Rentabilité
    Alors je vois les bonnes valeurs pour la VAN, le TRI et le délai de retour