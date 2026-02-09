# Big Mamma Clone

Ce projet est une reproduction front-end d'une section du site Big Mamma.

## 🛠️ Démarche de réalisation

Voici les étapes que j'ai suivies pour construire ce projet :

### 1. Structure HTML
Dans un premier temps, j'ai mis en place toute la structure HTML de la page. L'objectif était d'avoir le squelette des éléments : le titre, la zone des cartes (cards) et la section inférieure.

### 2. Stylisation
Une fois la structure en place, je suis passé au style. J'ai utilisé **Tailwind CSS** pour gérer la mise en page, les couleurs (via des variables CSS pour le thème) et la typographie. C'est à cette étape que j'ai rendu le design responsive.

### 3. Ajout des décorations
Pour coller au design original, j'ai intégré les éléments graphiques décoratifs :
- L'image `card_outline` pour donner un effet dessiné aux cartes.
- Le cercle "focus" (`line_focus_ellipse`) et l'ampoule pour habiller le fond.
- Le soulignement sous le titre dynamique.

### 4. Refactoring et Optimisation (JavaScript)
À la fin, je me suis rendu compte que le code HTML était très long et répétitif, notamment pour la liste des 12 cartes projets.
J'ai donc décidé d'optimiser cela en utilisant une **boucle JavaScript**.
- J'ai supprimé les blocs HTML répétitifs.
- J'ai créé un script qui génère automatiquement les 12 cartes.
- J'ai dupliqué certaines images pour avoir assez de contenu (12 items) pour la démonstration.

Cela rend le code beaucoup plus propre, plus court et plus facile à maintenir.
