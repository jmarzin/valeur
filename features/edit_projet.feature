# language: fr

Fonctionnalité: Modification des projets
  En tant que gestionnaire de projet
  De façon à tenir compte des changements
  Je veux pouvoir les modifier

  Scénario: contrôle de la navigation
    Etant donné un projet sans étude dans la base
    Quand je suis sur la page /projets
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
    |Etat      |Présentes             |Absentes                                                |
    |a_l_etude |soumis abandonne      |accepte rejete en_cours termine arrete                  |
    |soumis    |accepte refuse        |abandonne en_cours a_l_etude termine arrete             |
    |accepte   |abandonne             |soumis refuse en_cours a_l_etude termine arrete         |
    |refuse    |a_l_etude abandonne   |soumis accepte en_cours termine arrete                  |
    |abandonne |                      |soumis accepte refuse en_cours a_l_etude termine arrete |

  Plan du scénario: lancement d'un projet
    Etant donné un projet avec étude dans l'état <Etat>
    Quand je vais sur la page /projets/1/edit
    Alors je vois cet état <Etat> comme option et les options <Options>
    Et je ne vois pas les options <Absentes>

  Exemples:
    |Etat      |Options               |Absentes                                                  |
    |accepte   |abandonne en_cours    |soumis refuse a_l_etude termine arrete                    |
    |en_cours  |termine arrete        |soumis abandonne accepte refuse a_l_etude                 |
    |termine   |                      |soumis abandonne accepte refuse en_cours a_l_etude arrete |
    |arrete    |                      |soumis abandonne accepte refuse en_cours a_l_etude termine|
      
  Scénario: La liste des états permis évolue si l'état est modifié
    Etant donné un projet avec étude dans l'état a_l_etude
    Etant donné que je suis sur la page /projets/1/edit
    Etant donné que je sélectionne "soumis" dans la zone Etat
    Quand je suis le lien Modif
    Alors je ne vois pas l'option a_l_etude
    Etant donné que je sélectionne "accepte" dans la zone Etat
    Quand je suis le lien Modif
    Alors je ne vois pas l'option soumis

  Scénario: La liste des états permis ne doit pas changer en cas d'erreur après modification
    Etant donné un projet avec étude dans l'état a_l_etude
    Etant donné que je suis sur la page /projets/1/edit
    Etant donné que je ne saisis rien dans la zone projet_code
    Etant donné que je sélectionne "soumis" dans la zone Etat
    Quand je clique sur Enregistrer
    Alors je vois l'option a_l_etude