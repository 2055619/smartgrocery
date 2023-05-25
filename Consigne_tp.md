[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-24ddc0f5d75046c5622901739e7c5dd533143b0c8e959d652212380cedb1ea36.svg)](https://classroom.github.com/a/Jd7tHycT)
# Consignes

* Le travail est à réaliser individuellement
* Ce travail compte pour 20 % de la note finale
* La date de remise est le 19 mai 2023 à 21:00
* Le travail doit être remis par « commit » dans le projet Github Classroom, aucune autre méthode de remise ne sera acceptée
* Tout retard dans la remise de ce travail entraînera une pénalité de 10% par jour de retard jusqu’à concurrence de 5 jours. Après cette date, la note de zéro sera attribuée au travail.

# Alternatives

Vous trouverez ici la description d'un travail que vous pouvez effectuer comme travail final. Il est possible pour vous de proposer un travail différent pour le cours. Le document suivant indique les règles à suivre si vous désirez prendre cette approche: [Alternative](Alternative.md)

# Travail de synthèse : Gestion d'épicerie

## Concept
Créer une application de gestion de liste d'épicerie

Cette application permet à son usager de créer des listes d'épicerie et de les gérer. Votre application permettra à votre usager de maintenir une liste globale d'article et de gérer une épicerie permettant de faire un suivi des articles achetés.

Votre application devra contenir les fonctionnalités spécifiées. Vous aurez la flexibilité de choisir les types d'interfaces et la structure que vous désirez tant que les fonctionnalités décrites soient présentes. 

Il est acceptable de choisir un design différent en combinant des pages.

## Données et utilisateurs

Votre application doit supporter plusieurs utilisateurs. Il doit être possible pour un utilisateur n'ayant pas de compte de s'enregistrer sur votre page d'accueil pour créer un compte et ainsi avoir accès aux services de votre application.

Votre application doit permettre de gérer les données suivantes:

### Articles d'épicerie

La table des articles d'épicerie est une liste globale partagée entre tous les utilisateurs et permet de simplifier la construction de la liste d'épicerie en utilisant les articles créés par tous les utilisateurs pour les mettre dans notre épicerie.

* Une liste d'article d'épicerie qui est utilisée comme source pour créer une épicerie.
* Cette liste doit être partagée entre tous vos utilisateurs.
* Les articles d'épiceries doivent au minimum présenter les attributs suivants:
    * Nom de l'article
    * Utilisateur ayant ajouté l'article
    * Catégorie d'article permettant de filtrer les articles lors de la création de l'épicerie

### Épiceries

Les épiceries ne doivent pas être globales, elles doivent être visibles uniquement pour l'utilisateur ou le groupe qu'il a créé. Une épicerie contient une liste d'article qui doit être achetée pour l'épicerie. 

Votre structure doit contenir plusieurs listes d'épicerie permettant de maintenir un journal des épiceries passées. 

Une épicerie devrait contenir les informations suivantes:

* Date de l'épicerie (peut être nulle lorsque l'épicerie est planifiée, mais pas encore réalisée)
* Liste des articles à acheter pour l'épicerie
    * Cette liste doit avoir les attributs suivants
        * Indicateur d'ordre permettant d'avoir la liste ordonnée par notre usager
        * Article à acheter (Référence sur la liste globale des articles d'épicerie)
        * Statut de l'article tel : En attente d'achat, acheté, pas trouvé. Ce statut permettra de gérer l'affichage de la liste lors de l'épicerie
        * Date/heure de l'achat de l'article.

### Épicerie courante

L'épicerie courante permet de contenir la prochaine épicerie. Elle possède la même structure que la liste d'épicerie indiquée plus haut. 

L'épicerie courante doit être conservée localement dans une base de données de votre application. Ainsi si votre usager n'a pas accès à l'internet, il devrait tout de même être en mesure de faire son épicerie avec la liste locale. 

### Utilisateurs

Information sur vos utilisateurs. Permettant en autre de définir des groupes ou autres informations.

### Autres

Il est possible d'autres éléments de données selon les besoins de votre application.

## Fonctionnalités

Ici une liste des fonctionnalités à mettre dans votre application. Ici les fonctionnalités peuvent ou non représenter une page dans votre application.

### Groupe/Famille

* Vous devez avoir un concept de groupe ou un utilisateur doit pouvoir créer un groupe et ajouter d'autres utilisateurs dans ce groupe.
    * Pour fin de sécurité, un utilisateur doit connaitre le courriel de l'autre utilisateur pour l'ajouter dans un groupe. Vous ne devez pas afficher le courriel dans une liste.

### Page d'accueil

Cette page permet à l'usager de s'identifier. Si l'usager n'a pas de compte avec votre application, vous devez lui permettre de créer un compte à partir de cette page.

### Ajout articles

Il doit être possible pour votre utilisateur d'ajouter des articles dans la liste globale d'article. Ceci permettra à votre application de croitre avec une liste de plus en plus garnie d'article.

### Numérisation d'article

Pour ajouter des articles, vous devez offrir une fonction de numérisation qui permet d'utiliser la caméra pour scanner le code CUP. Lorsque votre application numérise un code, vous devez utiliser l'API du site  world.openfoodfacts.org pour récupérer les informations du produit et remplir automatiquement la liste d'article et/ou d'épicerie.

**NOTE: Vous devez aussi gérer les scénarios ou le code n'est pas trouvé dans la base de données en permettant à votre usager d'entrer les informations sur le produit**

### Liste d'épicerie

Votre utilisateur doit pouvoir voir les épiceries qui furent complétées. Il doit entre autres pouvoir revoir ce qui fut acheté ou non durant l'épicerie.

### Planification liste pour Épiceries

Il doit être possible de structurer une épicerie. Cette fonction doit permettre de facilement ajouter des articles et elle permet aussi d'ordonner la liste. Ici votre usager peut désirer mettre certains articles au haut pour correspondre à la séquence d'achat en magasin.

### Épicerie

Vous devez avoir une page permettant de faire l'épicerie. Durant cette opération, l'usager doit être en mesure d'indiquer les articles achetés. Si un article est acheté, il doit disparaitre de la liste (Il ne doit pas être retiré de la liste, car il doit être possible dans le futur de revoir la liste d'épicerie avec ce qui fut acheté, mais elle doit disparaitre de cette vue.). 

L'usager doit aussi être en mesure de signaler que l'article ne fut pas trouvé pour ainsi retirer l'article de la vue courante.

### Liste d'article

La liste d'article permet d'afficher tous les articles possibles. Cette liste devrait vous permettre d'offrir à votre utilisateur de faire la création d'une nouvelle épicerie avec une fonction permettant d'ajouter un élément de cette liste dans la liste d'épicerie courante.

Les articles contenant un code CUP/UPC doivent avoir une option pour afficher la vue détaillée sur l'article.

La liste d'article peut devenir très grande, vous devez prévoir une interface permettant de filtrer la liste par catégorie. 

### Vue détaillée d'un article

Lorsque l'application numérise un article ou bien que votre usager clique sur un article contenant un code CUP. Vous devez construire une page affichage donnant une vue détaillée de l'article. Il n'est pas requis de mettre toutes les informations disponibles sur API. 

Les éléments suivants devraient être présents: (Mais vous pouvez en ajouter si le cœur vous en dit.). Ce [lien](https://world.openfoodfacts.org/api/v2/search?code=066086092902) permet de récupérer un exemple d'information qui peut être récupéré par ce site web.

* Nom de l'article
* Catégories
* Image de l'article
* Information nutritive

## Matériel à remettre

* Code en utilisant Github dans le répertoire exercice TP-final
* Fichier readme.md pour contenir les informations suivantes:
    * Structure de vos bases de données
    * Règles implémentées pour protéger votre base de données Firestore (Contenu du tab) 
* Vidéo de 2 minutes ou vous démontrez le fonctionnement de votre application

### Exemple de règles

![](reglesdb.png)

## Grille d'évaluation:

Le travail pratique sera évalué sur le respect des fonctionnalités ainsi que la qualité de l'application. 

| Pondération | Fonctionnalité/Aspect |
| --- | --- |
| 5 | Gestions des utilisateurs autorisation ou création d'utilisateurs |
| 10 | Il y a une liste d'articles qui est globale pour tous les utilisateurs |
| 5 | Un utilisateur peut voir les épiceries passées |
| 5 | Les utilisateurs faisant partie du même groupe partagent les épiceries ensemble |
| 10 | Il est possible de gérer une épicerie en y ajoutant des éléments |
| 5 | Il est possible de changer l'ordre des articles dans la liste d'épicerie |
| 5 | Il est possible d'ajouter un article dans les listes manuellement |
| 5 | Il est possible d'ajouter un article dans les listes avec une numérisation de code CUP |
| 10 | Il y a une vue permettant de faire l'épicerie |
| 5 | Lors de l'épicerie, l'utilisateur peut marquer un article comme acheté |
| 5 | Lors de l'épicerie l'utilisateur peur marquer un article comme absent |
| 5 | L'utilisateur peut voir une vue détaillée d'un article |
| 5 | Les bases de données ont des règles permettant de limiter l'accès aux utilisateurs. |
| 5 | L'épicerie courante existe en mémoire et est accessible sans accès à l'internet |
| 5 | L'utilisateur peut filtrer la liste par catégorie |
| 10 | Qualité de l'interface |

# Libraires

Les librairies suivantes peuvent être utilisées pour vous permettre de réaliser le travail. Bien entendu d'autres librairies pourront et devront être utilisées.

# Bar code scanner
Intégrer https://pub.dev/packages/flutter_barcode_scanner

# Exemple de query

## Récupération d'un nom de produit
https://world.openfoodfacts.org/api/v2/search?code=066086092902&fields=code,product_name

## Récupération de toutes les infos pour un code
https://world.openfoodfacts.org/api/v2/search?code=066086092902

