#Étape 1 : Installer et charger les bibliothèques nécessaires
# Installer les bibliothèques (à exécuter une seule fois)
install.packages("tidyverse")    
install.packages("caret")       
install.packages("e1071")        
install.packages("caTools")     
install.packages("wooldridge")
install.packages("readxl")
install.packages("lmtest")
install.packages("dplyr")
install.packages("car")
install.packages("AER")
install.packages("sandwich")
library(wooldridge)
library(lmtest)
library(readxl)
library(dplyr)
library(sandwich)
library(AER)
library(car) 
library(tidyverse)
library(caret)
library(e1071)
library(caTools)

# Contexte et Motivation

#Le diabète est une maladie chronique qui peut être gérée ou prévenue si elle est détectée à un stade précoce. Utiliser des techniques sur des données de santé permet de prédire les risques de développer le diabète, aidant ainsi les professionnels de la santé à prendre des décisions plus éclairées et à orienter les patients vers des traitements ou des conseils personnalisés.

# Objectifs


# Modèle prédictif : Développer un modèle pour prédire le risque de diabète chez une personne en fonction de caractéristiques médicales telles que l'âge, l'indice de masse corporelle (IMC), le taux de glucose, etc.

# Analyse des facteurs : Identifier les variables les plus importantes qui influencent le risque de diabète.

# Visualisation : Présenter les résultats sous forme de graphiques pour mieux comprendre le modèle et ses performances.



# Jeu de données

## Notre projet utilisera le Pima Indians Diabetes Database, disponible sur des plateformes Kaggle. Ce jeu de données contient des informations médicales sur des femmes âgées de plus de 21 ans issues de la communauté Pima, un groupe ethnique avec un taux de diabète élevé.

## Caractéristiques des données :

#Pregnancies : Nombre de grossesses.
#Glucose : Concentration de glucose dans le plasma.
#Blood Pressure : Tension artérielle diastolique.
#Skin Thickness : Épaisseur de la peau du triceps.
#Insulin : Taux d'insuline.
#BMI : Indice de masse corporelle (poids/hauteur²).
#Diabetes Pedigree Function : Probabilité de diabète basée sur les antécédents familiaux.
#Age : Âge de la personne.
#Outcome : Indicateur si la personne est atteinte de diabète (1) ou non (0).



#Étape 2 : Charger et explorer les données

# Charger les données (le chemin du fichier doit être correct)

data<-read_excel("Downloads/Projet Econométrie ETIC/Analyse de données/diabete.xlsx")
View(data)

# Afficher les premières lignes des données
head(data)

# Avoir une vue d'ensemble du dataset
summary(data)

# Vérifier les types de données et les valeurs manquantes
str(data)

#Étape 3 : Prétraitement des données
#Vérifier et traiter les valeurs manquantes : Parfois, certaines variables comme le glucose, la pression artérielle ou l'insuline peuvent avoir des valeurs manquantes, représentées par des zéros.
#Remplacer les zéros par NA (valeurs manquantes) :
#Les variables concernées : Glucose, BloodPressure, SkinThickness, Insulin, BMI.

# Remplacer les zéros par NA dans certaines colonnes
data <- data %>%
  mutate(Glucose = ifelse(Glucose == 0, NA, Glucose),
         BloodPressure = ifelse(BloodPressure == 0, NA, BloodPressure),
         SkinThickness = ifelse(SkinThickness == 0, NA, SkinThickness),
         Insulin = ifelse(Insulin == 0, NA, Insulin),
         BMI = ifelse(BMI == 0, NA, BMI))

# Vérifier les valeurs manquantes
summary(data)

#Gérer les valeurs manquantes : Pour simplifier, vous pouvez soit supprimer les lignes avec des valeurs manquantes, soit imputer les données manquantes (par exemple, avec la médiane).

# Imputer les valeurs manquantes avec la médiane
data <- data %>%
  mutate(Glucose = ifelse(is.na(Glucose), median(Glucose, na.rm = TRUE), Glucose),
         BloodPressure = ifelse(is.na(BloodPressure), median(BloodPressure, na.rm = TRUE), BloodPressure),
         SkinThickness = ifelse(is.na(SkinThickness), median(SkinThickness, na.rm = TRUE), SkinThickness),
         Insulin = ifelse(is.na(Insulin), median(Insulin, na.rm = TRUE), Insulin),
         BMI = ifelse(is.na(BMI), median(BMI, na.rm = TRUE), BMI))




#Étape 4 : Diviser les données en ensemble d'entraînement et de test
#Nous allons séparer les données en deux ensembles : 80 % pour l'entraînement et 20 % pour le test.

#Diviser les données en un ensemble d'entraînement (80 %) et un ensemble de test (20 %) nous permet d'évaluer la performance d'un modèle de manière objective. L'ensemble d'entraînement sert à apprendre les motifs dans les données, tandis que l'ensemble de test, non utilisé pour l'entraînement, permet de mesurer la capacité du modèle à généraliser sur des données nouvelles et jamais vues. Cette séparation aide à détecter le surapprentissage (ou overfitting) et à s'assurer que le modèle est performant sur des données réelles, et pas seulement sur celles avec lesquelles il a été formé.

# Fixer la graine aléatoire pour la reproductibilité
set.seed(123)

# Diviser les données en ensemble d'entraînement (80%) et de test (20%)
split <- sample.split(data$Outcome, SplitRatio = 0.8)
train_data <- subset(data, split == TRUE)
test_data <- subset(data, split == FALSE) #convertir BMI et DiabetesPedigreeFunction avant
 
#Convertion de BMI en numérique dans les deux ensembles

train_data$BMI <- as.numeric(as.character(train_data$BMI))
test_data$BMI <- as.numeric(as.character(test_data$BMI))

train_data$DiabetesPedigreeFunction <- as.numeric(as.character(train_data$DiabetesPedigreeFunction))
test_data$DiabetesPedigreeFunction <- as.numeric(as.character(test_data$DiabetesPedigreeFunction))


# Vérifier la taille des ensembles

nrow(train_data)
nrow(test_data)

#Interpretation:

#614 représente la taille de l'ensemble d'entraînement, soit 80 % des données.
#154 représente la taille de l'ensemble de test, soit 20 % des données.

#Cela signifie que sur l'ensemble total de  nos données initiales, 614 exemples ont été utilisés pour entraîner le modèle, et 154 exemples ont été mis de côté pour tester la performance. Cette répartition permet de vérifier que le modèle apprend bien à partir de 614 cas et peut généraliser correctement à 154 nouveaux cas.

#Étape 5 : Entraîner le modèle de régression logistique
#La régression logistique est un bon point de départ pour un problème de classification binaire comme celui-ci (diabète ou pas diabète).

#Cela signifie que sur l'ensemble total de  nos données initiales, 614 exemples ont été utilisés pour entraîner le modèle, et 154 exemples ont été mis de côté pour tester la performance. Cette répartition permet de vérifier que le modèle apprend bien à partir de 614 cas et peut généraliser correctement à 154 nouveaux cas.

# Entraîner un modèle de régression logistique
model_logistic <- glm(Outcome ~ ., data = train_data, family = binomial)

# Résumé du modèle
summary(model_logistic)

#Interpretation: 
#Notre modèle de régression logistique nous montre que certaines variables ont un impact significatif sur la probabilité d'avoir le diabète :
#Glucose, BMI (indice de masse corporelle), nombre de grossesses, et insuline sont les variables les plus significatives pour prédire le diabète.

#Les autres variables, comme la pression artérielle, l'épaisseur de la peau et l'âge, ne semblent pas significativement influencer le risque de diabète dans notre modèle.

#Le modèle réduit bien la déviance résiduelle par rapport à la déviance nulle, indiquant qu'il est capable de mieux prédire le diabète qu'un modèle sans variables explicatives.

#Étape 6 : Évaluer le modèle sur l'ensemble de test
#Nous allons faire des prédictions sur l'ensemble de test et évaluer les performances du modèle à l'aide de mesures comme la matrice de confusion.

# Prédire sur l'ensemble de test
predictions <- predict(model_logistic, test_data, type = "response")
# Valeurs réelles
valeurs_reelles <- test_diabete$Outcome  

# Création du graphique
plot(1:length(predictions), predictions, col = "blue", pch = 16, 
     xlab = "Index des échantillons", ylab = "Probabilité prédite / Valeurs réelles", 
     main = "Probabilités prédites vs valeurs réelles")
points(1:length(valeurs_reelles), valeurs_reelles, col = "red", pch = 4)
legend("topright", legend = c("Probabilités prédites", "valeurs réelles"), 
       col = c("blue", "red"), pch = c(16, 4))

#Interpretation:Ce graphique montre que notre modèle fait des prédictions assez variées. Le modèle semble bien différencier les patients avec et sans diabète dans de nombreux cas, mais il y a aussi quelques erreurs de prédiction: il y a des cas où les prédictions ne correspondent pas aux valeurs réelles, comme des points bleus proches de 0 avec des croix rouges à 1, ce qui pourrait indiquer des erreurs de classification. Un examen plus approfondi des performances globales du modèle (via des mesures comme la courbe ROC ou la matrice de confusion) pourrait être utile pour évaluer la qualité de ces prédictions.

# Convertir les probabilités en classes (1 ou 0)
predicted_classes <- ifelse(predictions > 0.5, 1, 0)

# Créer une matrice de confusion
conf_matrix <- table(test_data$Outcome, predicted_classes)

# Afficher la matrice de confusion
conf_matrix

#Interpretation: 
  
#Signification des valeurs :
#84 (Vrais négatifs) : Ce sont les individus sans diabète (classe réelle = 0) correctement prédits comme n'ayant pas le diabète (prédit = 0).
#16 (Faux négatifs) : Ce sont les individus sans diabète (réel = 0), mais le modèle a incorrectement prédit qu'ils avaient le diabète (prédit = 1).
#25 (Faux positifs) : Ce sont les individus qui ont le diabète (réel = 1), mais le modèle a incorrectement prédit qu'ils n'en avaient pas (prédit = 0).
#29 (Vrais positifs) : Ce sont les individus ayant le diabète (réel = 1) correctement prédits comme ayant le diabète (prédit = 1).
#Le modèle parvient à détecter des personnes diabétiques, mais il y a aussi des cas où il ne détecte pas correctement (25 fois).

# Calculer l'exactitude
accuracy <- sum(diag(conf_matrix)) / sum(conf_matrix)
accuracy

#Interprétation :
#Une accuracy (une précision) de 73,37 % indique que le modèle a une performance correcte, mais il laisse encore environ 26,63 % d'erreurs (faux positifs ou faux négatifs).Autrement, Sur 100 échantillons, environ 73 sont correctement classifiés (qu'il s'agisse de personnes avec ou sans diabète).

#Globalement, bien qu'une accuracy de 73 % soit décente, il pourrait être utile d'examiner d'autres métriques ou de tester des méthodes pour améliorer ce taux, notamment en réduisant les faux négatifs ou faux positifs.


#Étape 7 : Visualisation des résultats
#Visualiser les résultats peut vous aider à mieux comprendre les performances du modèle.

#Courbe ROC et AUC :
#La courbe ROC est un excellent moyen de visualiser la performance d'un modèle de classification.
#La courbe ROC (Receiver Operating Characteristic) est un  excellent moyen de visualiser la performance d'un modèle de classification binaire. Elle représente la relation entre le taux de vrais positifs (sensibilité ou recall) et le taux de faux positifs pour différents seuils de décision.


# Installer le package pROC si nécessaire
install.packages("pROC")
library(pROC)

# Tracer la courbe ROC et calculer l'AUC
roc_curve <- roc(test_data$Outcome, predictions)
plot(roc_curve, col = "blue", main = "Courbe ROC")

#La courbe ROC trace la sensibilité en fonction de 1. La ligne en diagonale grise représente un modèle de classification aléatoire, c'est-à-dire un modèle qui prédit sans information pertinente (AUC = 0.5). Plus notre courbe s'éloigne de cette diagonale vers le coin supérieur gauche, meilleur est notre modèle.

auc(roc_curve)

#Une AUC de 0.8341, signifie que notre modèle a une bonne performance globale dans la classification des données. En d'autres termes, il a environ 83.41% de chances de classer correctement un exemple positif par rapport à un exemple négatif.
#Notre modèle est performant et peut bien distinguer les classes positives et négatives dans l'ensemble de test.

#Étape 8 : Essayer d'autres modèles (Random Forest, SVM, etc.)
#on peut tester différents algorithmes pour voir lequel donne les meilleures performances. Voici un exemple pour Random Forest et SVM.

# Installer le package randomForest si nécessaire
install.packages("randomForest")
library(randomForest)

# Entraîner un modèle Random Forest

#Un modèle Random Forest est une méthode d'apprentissage automatique utilisée principalement pour les tâches de classification et de régression. Il fonctionne en combinant plusieurs arbres de décision pour créer une forêt. Chaque arbre est construit à partir d'un sous-ensemble aléatoire des données et des caractéristiques, ce qui réduit le risque de surapprentissage (overfitting) et améliore la performance du modèle. En prédiction, le Random Forest agrège les résultats des différents arbres (par majorité pour la classification ou moyenne pour la régression) afin de fournir une décision finale plus robuste et fiable.


# Convertir Outcome en facteur dans les deux jeux de données
train_data$Outcome <- as.factor(train_data$Outcome)
test_data$Outcome <- as.factor(test_data$Outcome)

model_rf <- randomForest(Outcome ~ ., data = train_data, ntree = 100)
summary(model_rf)

#Interpretation:
#Random Forest nous montre les principales composantes du modèle, telles que les prédictions, la matrice de confusion, les votes des arbres pour chaque classe, et les mesures d'importance des variables. Il inclut également des informations sur les taux d'erreur, les valeurs cibles et le nombre d'arbres utilisés. Certaines fonctionnalités avancées comme la proximité et l'importance locale ne sont pas activées. Le modèle est utilisé pour une tâche de classification avec 614 observations dans l'ensemble d'apprentissage.

# Prédictions et évaluation sur l'ensemble de test
pred_rf <- predict(model_rf, test_data)
conf_matrix_rf <- table(test_data$Outcome, pred_rf)
conf_matrix_rf

Interprétation :
  
#Vrais négatifs (70) : notre modèle a correctement prédit que 70 personnes n'ont pas de diabète (classe 0).
#Faux positifs (30) : notre modèle a incorrectement prédit que 30 personnes avaient le diabète, alors qu'elles ne l'avaient pas.
#Faux négatifs (38) : notre modèle a prédit que 38 personnes n'avaient pas le diabète, alors qu'elles en avaient effectivement.
#Vrais positifs (16) : notre modèle a correctement prédit que 16 personnes avaient le diabète (classe 1).

#Cette matrice permet de mieux comprendre où se trouvent les erreurs de prédiction du modèle, avec un nombre relativement élevé de faux négatifs, ce qui peut poser problème dans un contexte médical, car cela signifie que le modèle pourrait manquer des cas de diabète.

# Calculer l'exactitude
accuracy_rf <- sum(diag(conf_matrix_rf)) / sum(conf_matrix_rf)
accuracy_rf
#La précision de notre modèle est de 0.7922, soit environ 79.22%. Cela signifie que dans 79.22% des cas, le modèle a correctement classé les individus entre ceux qui ont le diabète et ceux qui ne l'ont pas.
#Conclusion :
#Avec une précision de 79.22%, le modèle montre une performance acceptable pour la prédiction du diabète, bien qu'il commette encore un nombre significatif d'erreurs, notamment des faux négatifs (38). Cela signifie qu'il pourrait manquer certains cas de diabète, ce qui est une préoccupation dans un contexte médical.

### Entraîner un modèle SVM
model_svm <- svm(Outcome ~ ., data = train_data)

# Prédictions et évaluation sur l'ensemble de test
pred_svm <- predict(model_svm, test_data)
conf_matrix_svm <- table(test_data$Outcome, pred_svm)
conf_matrix_svm

# Calculer l'exactitude
accuracy_svm <- sum(diag(conf_matrix_svm)) / sum(conf_matrix_svm)
accuracy_svm













