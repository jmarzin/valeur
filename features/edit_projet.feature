# language: fr

Fonctionnalité: Modification des projets
  En tant que gestionnaire de projet
  De façon à tenir compte des changements
  Je veux pouvoir les modifier

  Scénario: contrôle de la navigation
    Etant donné un projet sans étude dans la base
    Quand je suis sur la page projets
    Quand je suis le lien Modif
    Alors je me retrouve sur la page /projets/1/edit

  Scénario: gestion de la Quotation
    Etant donné un projet sans étude dans la base
    Quand je vais sur la page /projets/1/edit
    Alors je vois un sélecteur de Quotation

  Scénario: gestion de l'Etat
    Etant donné un projet sans étude dans la base
    Quand je vais sur la page /projets/1/edit
    Alors je vois un sélecteur d'Etat

  Plan du scénario: gestion de l'état
    Etant donné un projet sans étude dans l'état <Etat>
    Quand je vais sur la page /projets/1/edit
    Alors je vois cet état <Etat> comme option et les options <Présentes>
    Et je ne vois pas les options <Absentes>

  Exemples:
    |Etat      |Présentes             |Absentes                                                                 |
    |a_l_etude |soumettre abandonner  |accepter rejeter lancer re_etudier terminer arreter                      |
    |soumis    |accepter rejeter      |soumettre abandonner lancer re_etudier terminer arreter                  |
    |accepte   |abandonner            |soumettre accepter rejeter lancer re_etudier terminer arreter            |
    |rejete    |re_etudier abandonner |soumettre accepter rejeter lancer terminer arreter                       |
    |abandonne |                      |soumettre abandonner accepter rejeter lancer re_etudier terminer arreter |

  Plan du scénario: lancement d'un projet
    Etant donné un projet avec étude dans l'état <Etat>
    Quand je vais sur la page /projets/1/edit
    Alors je vois cet état <Etat> comme option et les options <Options>
    Et je ne vois pas les options <Absentes>

  Exemples:
    |Etat      |Options               |Absentes                                                                 |
    |accepte   |abandonner lancer     |soumettre accepter rejeter re_etudier terminer arreter                   |
    |en_cours  |terminer arreter      |soumettre abandonner accepter rejeter lancer re_etudier                  |
    |termine   |                      |soumettre abandonner accepter rejeter lancer re_etudier terminer arreter |
    |arrete    |                      |soumettre abandonner accepter rejeter lancer re_etudier terminer arreter |
      
 
