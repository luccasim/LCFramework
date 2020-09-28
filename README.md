# MyLibrary


## Architecture

In our project we will use Protocol-Oriented Programming that simplifies architecting iOS apps, helps us avoid a tight coupling of classes with one another, allows as to use all the power of structs and enums by conforming them to protocols and makes it easier to write unit tests.

### MVVM

l'architecture MVVM est une couche qui traite la buisness logique de l'application. Elle est en relation avec le controller et les differents services (WebService, DataBase, Preferences, Settings etc...). Ainsi chaque vue possedent sont view model (les cellules des table view n'en possèdent pas.).

Les view Models sont construit par injection de leur dépendance. Cela permet de rendre les services indépendant de l'application et de testé plus facilement les view Model.

### Context

Le context défini l'environnement dans lequel l'application est utilisé (Production, Intégration, Testing...). Il regroupe l'ensemble des Services qui seront partager dans les vues de l'application.

## Testings

### Unit Test

Tous les services

### Test Doubles

Toutes les classes avec des dépendances sont testé selon [les principes de Martin Fowler](https://martinfowler.com/bliki/TestDouble.html) 

### Tests UI (end-to-end)
