#  Tests

## Overview

Les tests permettent d'augmenter la qualité du code et du projets, en assurant un bon comportement en fonction des environements d'applications. Cela permet également d'éviter les erreurs de régresssion.

Une convention de test est d'attribuer une seul assertion par test (l'objectif du test).

## Test Unitaires

Le test Unitaire est un moyen de tester un paramêtre ou une méthode de manière isoler. Ils doivent être simple, rapide et court.

## Test Doubles

Les tests doubles permettent d'effectuer des test sur des objets utilisant les dépendances. L'objectif n'est pas de testé les dépendance mais bien le comportement de l'objet avec des dépendances "fausses". On parle de mock, principe d'utiliser une dépendance par encore implémenter. Les mocks peuvent avoir plusieurs roles différent :
- le Stub est une implementation vide, sans logique. A stub is a fake that provides a canned response when it is called.
- A mock is a fake that records how it was called.
- le Fake est une implementation fausse.
- le Dummy est une implementation qui cause un crash lors de l'appel d'un parametre.
- le Spy est une implementation qui trace les appels (compte le nombre d'appel, description des états etc...)

+ Then each test should set up a single scenario. For example, you can pretend you got valid JSON with various parameters. You can pretend to get various error responses.


## Test d'intégration

Les tests d'intégration permettent de tester des morceaux de code

## TestsUI

Les testsUI permettent de testé un scénario, permet de reproduire le comportement d'un utilisateur afin de contrôler le comportement de l'application.

## TestPlan

Les test plan permettent

## Code Coverage

Permet de tracer le code les variable et methodes appeler lors de l'execution de l'application. Pour l'activer sous Xcode aller dans Editor et cocher Code Coverage.



