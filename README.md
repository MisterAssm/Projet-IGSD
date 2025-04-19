# IGSD – Projet de Génération de Cartes et Recherche de Chemin

**IGSD** est un projet universitaire développé en Java avec la librairie Processing. Il met en œuvre des concepts avancés tels que le bruit de Perlin pour la création de cartes et l'algorithme A* pour la navigation.

---

## Table des matières

- [Introduction](#introduction)
- [Objectifs du projet](#objectifs-du-projet)
- [Fonctionnalités principales](#fonctionnalités-principales)
- [Algorithmes et techniques utilisés](#algorithmes-et-techniques-utilisés)
- [Structure du projet](#structure-du-projet)
- [Contributeurs](#contributeurs)
- [Licence](#licence)

---

## Introduction

Ce projet a été réalisé dans le cadre d'un module universitaire, visant à explorer la recherche de chemin efficace. Il s'inspire de jeux vidéo et d'applications nécessitant une navigation intelligente dans des environnements dynamiques.

---

## Objectifs du projet

- Générer des cartes de terrain de manière procédurale, offrant diversité et réalisme.
- Implémenter des algorithmes de recherche de chemin pour permettre à des entités de naviguer efficacement.
- Visualiser les cartes et les chemins calculés pour une meilleure compréhension et analyse.

---

## Fonctionnalités principales

- **Génération de cartes** : Utilisation du bruit de Perlin pour la création d'un terrain naturel.
- **Recherche de chemin** : Implémentation de l'algorithme A* pour trouver le chemin le plus court entre deux points.
- **Visualisation** : Affichage graphique des cartes générées et des chemins calculés.
- **Personnalisation** : Paramètres ajustables pour modifier la complexité du terrain et les heuristiques de l'algorithme.

---

## Algorithmes et techniques utilisés

### Bruit de Perlin

Le bruit de Perlin est utilisé pour générer des cartes de terrain réalistes. Il permet de créer des variations douces et naturelles, simulant des éléments tels que des collines, des vallées et des plateaux.

### Algorithme A*

L'algorithme A* est un algorithme de recherche de chemin efficace, combinant les avantages de la recherche en largeur et de la recherche informée. Il utilise une fonction heuristique pour estimer le coût restant jusqu'à la destination, optimisant ainsi le parcours.

---

## Structure du projet

```
Projet-IGSD/
├── boussole/              # Modèle de la boussole + logique de fonctionnement et animation
├── labyrinthe/            # Génération procédurale du labyrinthe + rendu 2D avec effet 3D (shader)
├── momie/                 # Modèle 3D de la momie
├── projet-final/          # Code complet finalisé, intégration de tous les modules
├── IGSD-G1L2Info-ZEMOUCHI-HIDOUCHE.pdf   # Rapport de projet
└── README.md              # Documentation du projet
```


---

## Contributeurs

- [Assim Zemouchi](mailto:assim.zemouchi@universite-paris-saclay.fr?subject=[GitHub]%20Projet%20IGSD)
- [Anaïs Hidouche](mailto:ouarda.hidouche@universite-paris-saclay.fr?subject=[GitHub]%20Projet%20IGSD)

---

## Licence

Ce projet est sous **licence Unlicense**. Cela signifie que vous pouvez l'utiliser, le modifier et le redistribuer librement, sans aucune restriction.

---

> Pour plus de détails, consultez le [rapport complet du projet](https://github.com/MisterAssm/Projet-IGSD/blob/main/IGSD-G1L2Info-ZEMOUCHI-HIDOUCHE.pdf).
