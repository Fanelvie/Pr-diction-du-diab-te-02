# Prédiction du diabète

Modèle pour prédire le risque de diabète chez une personne en fonction de caractéristiques médicales.

# Contexte et Motivation

Le diabète est une maladie chronique qui peut être gérée ou prévenue si elle est détectée à un stade précoce. Utiliser des techniques sur des données de santé permet de prédire les risques de développer le diabète, aidant ainsi les professionnels de la santé à prendre des décisions plus éclairées et à orienter les patients vers des traitements ou des conseils personnalisés.


# Objectifs


- Développer un modèle pour prédire le risque de diabète chez une personne en fonction de caractéristiques médicales telles que l'âge, l'indice de masse corporelle (IMC), le taux de glucose, etc.
- Identifier les variables les plus importantes qui influencent le risque de diabète.
- Présenter les résultats sous forme de graphiques pour mieux comprendre le modèle et ses performances.

# 
Prédiction du diabète à partir de la base de données des Indiens Pima
Ce projet est une application de prédiction du diabète basée sur les données de la base de données des Pima Indians Diabetes. Nous avons utilisé le langage R pour traiter les données, effectuer des analyses statistiques, et mettre en place un modèles pour prédire l'apparition du diabète chez les patients. Notre modèle est basé sur l'apprentissage automatique et utilise des caractéristiques telles que l'âge, le nombre de grossesses, l'indice de masse corporelle (IMC), et d'autres mesures médicales pour prédire la présence du diabète.

# Table des matières

- Installation

- Utilisation

- Données

- Modèles 

- Résultats

- Contribuer

- Licence

# Installation

Prérequis

R doit être installé sur votre machine. Vous pouvez télécharger la dernière version de R sur le site officiel de R.

Il est recommandé d'installer RStudio pour une expérience de développement plus fluide. RStudio est un IDE dédié à R.


Étapes d'installation

- Clonez le dépôt sur votre machine locale :

`git clone https://github.com/Fanelvie/Pr-diction-du-diab-te-02.git
cd Pr-diction-du-diab-te-02`


- Installez les packages R nécessaires :
Le script principal en R utilise des bibliothèques spécifiques pour le traitement des données et la modélisation. Vous pouvez installer ces bibliothèques avec la commande suivante :

`install.packages(c("ggplot2", "dplyr", "caret", "ROCR", "e1071"))`


- Charger les données :
La base de données Pima Indians Diabetes Database est disponible dans le répertoire du projet. Assurez-vous que les fichiers .csv sont bien chargés avant de démarrer le script principal.

`data <- read.csv("pima_indians_diabetes.csv")`


# Utilisation


Description des données
Source des données

La base de données Pima Indians Diabetes Database est accessible publiquement sur le site ***Kaggle***. Elle est composée de données cliniques relatives à plusieurs femmes des Pimas indiens (une population indigène d'Amérique). Chaque ligne représente un enregistrement de patient avec des caractéristiques comme :

Lien vers la base de données : [Pima Indians Diabetes Database](https://www.kaggle.com/datasets/uciml/pima-indians-diabetes-database)


Pregnancies : Nombre de grossesses.`


Glucose : Concentration de glucose dans le sang.


BloodPressure : Pression artérielle diastolique (mm Hg).


SkinThickness : Épaisseur du pli cutané tricipital (mm).


Insulin : Insulinémie après 2 heures (mu U/ml).


BMI : Indice de masse corporelle.


DiabetesPedigreeFunction : Fonction généalogique du diabète (indicateur de susceptibilité génétique).


Age : Âge de la personne (années).


Outcome : Variable cible (1 = diabète, 0 = non diabétique).


#

Exécution du script
Après avoir installé les dépendances et chargé les données, vous pouvez exécuter le fichier diabetes_prediction.R qui contient le code pour la prédiction du diabète.

`source("diabetes_prediction.R")`

Le script effectue les étapes suivantes :

Exploration des données : Visualisation des différentes variables et des relations entre elles.

Prétraitement des données : Nettoyage des données, traitement des valeurs manquantes et normalisation.

Modélisation : Application de plusieurs modèles prédictifs comme :


- Régression logistique : Un modèle simple pour les tâches de classification binaire.
- Random Forest : Un ensemble d'arbres de décision, performant et capable de gérer les données manquantes.

Évaluation des modèles : Calcul des métriques de performance comme la précision, le rappel.

#
Résultats

Les résultats de la prédiction du diabète sont affichés sous forme de :

- Matrice de confusion : Visualise les vrais positifs, faux positifs, vrais négatifs, et faux négatifs.
- Courbe ROC : Visualisation de la performance du modèle avec les courbes ROC et les scores AUC.

Les graphiques sont enregistrés dans le répertoire visualisations.

Exemple d'analyse visuelle
Le script génère également des graphiques pour explorer les données et les résultats des modèles prédictifs. Voici un exemple de la courbe ROC, qui est utilisée pour évaluer la performance des modèles :

`plot(roc_curve)`


![performance des modèles](https://github.com/Fanelvie/Pr-diction-du-diab-te-02/blob/69a77906a8d03902c40a46cd1f576beb0b65af75/visualisations/Rplot-Roc.png?raw=true)



# Contribuer

Nous accueillons toutes les contributions au projet. Si vous souhaitez ajouter des fonctionnalités ou corriger des bugs, suivez ces étapes :

Forkez ce dépôt sur votre compte GitHub.
Créez une branche pour vos modifications :

`git checkout -b feature-ajout-nouvelle-fonctionnalité`

Apportez vos modifications au code et commit vos changements :

`git commit -am "Ajout de la fonctionnalité XYZ"`

Push la branche vers votre dépôt distant :

`git push origin feature-ajout-nouvelle-fonctionnalité`

Ouvrez une Pull Request pour proposer vos changements. Assurez-vous d'expliquer les raisons de vos modifications et d'ajouter des détails si nécessaire.

# Licence

Ce projet est sous licence MIT, ce qui signifie que vous êtes libre de l'utiliser, le modifier et le distribuer comme bon vous semble, sous réserve d'attribution appropriée. 

