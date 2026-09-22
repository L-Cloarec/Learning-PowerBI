# Analyse et visualisation des données e-commerce — Olist

## 1. Présentation du projet

Ce projet consiste à analyser les données du **Brazilian E-Commerce Public Dataset by Olist** ([Kaggle](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce/data)) afin d'explorer les performances commerciales, les comportements des clients, les produits et catégories ainsi que la qualité des livraisons.

L'objectif est de transformer un ensemble de données e-commerce multi-tables en un tableau de bord interactif permettant d'explorer les principaux indicateurs commerciaux et opérationnels.

Le projet a été réalisé dans une démarche de mise en pratique des compétences en **analyse de données, SQL, modélisation de données, DAX et Power BI**.

## 2. Objectifs

L'analyse cherche notamment à répondre aux questions suivantes :

* Quelle est l'évolution du chiffre d'affaires et du nombre de commandes ?
* Quels États brésiliens génèrent le plus de commandes et de chiffre d'affaires ?
* Quelles catégories de produits représentent la plus grande part de l'activité ?
* Quels produits génèrent le plus de chiffre d'affaires ?
* Quel est le comportement d'achat des clients ?
* Quelle proportion de clients effectue plusieurs commandes ?
* Comment les dépenses des clients sont-elles réparties ?
* Quels sont les délais moyens de livraison ?
* Quelle proportion des commandes est livrée en avance ou en retard ?
* Existe-t-il une relation entre le statut de livraison et la satisfaction des clients ?

## 3. Données

Les principales tables utilisées sont :

* **`customers`** : informations sur les clients et leur localisation
* **`orders`** : informations relatives aux commandes et à leur statut
* **`order_items`** : produits et montants associés aux commandes
* **`order_payments`** : informations sur les paiements
* **`order_reviews`** : évaluations laissées par les clients
* **`products`** : informations sur les produits
* **`sellers`** : informations sur les vendeurs
* **`geolocation`** : données géographiques
* **`product_category_name_translation`** : traduction des catégories de produits

## 4. Tableau de bord

Le dashboard est organisé en **4 pages analytiques**.

### Vue d'ensemble

Cette page fournit une vue générale de l'activité commerciale avec le nombre de commandes, le chiffre d'affaires, le nombre de clients uniques et le panier moyen.

Les indicateurs sont interactifs et peuvent être analysés selon la période ou la localisation sélectionnée.

### Produits & catégories

Cette page est consacrée à l'analyse des produits commercialisés avec le chiffre d'affaires généré par les produits, le nombre d'articles vendus et le prix moyen des articles.

Les catégories ont été retraitées afin d'améliorer leur lisibilité dans les visualisations.

### Clients & commandes

Cette page analyse le comportement d'achat des clients.

Une segmentation des clients selon leurs dépenses permet notamment d'observer la distribution des comportements d'achat.

Les clients ayant effectué plusieurs commandes sont également distingués afin d'étudier la récurrence des achats.

### Livraison & satisfaction

Cette page cherche à étudier la performance des livraisons et son lien avec la satisfaction client.

Elle présente notamment le délai moyen de livraison, le retard moyen, le taux de commandes en retard et la note moyenne.

L'objectif est notamment d'explorer si les différences de délai de livraison sont associées à des différences de satisfaction exprimée dans les avis clients.

## 5. Méthodologie

Le projet a été réalisé selon plusieurs étapes :

### Exploration des données

Identification des différentes tables, de leurs variables et de leurs relations.

### Analyse SQL

Création de requêtes permettant notamment d'explorer :

* l'activité des clients ;
* les commandes ;
* les produits ;
* les paiements ;
* les avis ;
* les délais de livraison.

### Modélisation

Construction du modèle relationnel dans Power BI et définition des relations entre les différentes tables.

### Création des indicateurs

Création des mesures DAX nécessaires au suivi des performances commerciales, du comportement client et de la qualité des livraisons.

### Visualisation

Construction d'un dashboard composé de quatre pages thématiques.

### Interactivité

Ajout de filtres, interactions entre visualisations, navigation entre pages et info-bulles contextuelles.

---

Ce projet a été réalisé dans le cadre d'une démarche de développement de compétences en **Data Analysis et Business Intelligence**, avec un intérêt particulier pour l'exploitation de données, la création d'indicateurs et la visualisation de données permettant d'appuyer la prise de décision.

Le dataset est utilisé dans le cadre de ce projet à des fins d'apprentissage et de démonstration des compétences en analyse de données.
