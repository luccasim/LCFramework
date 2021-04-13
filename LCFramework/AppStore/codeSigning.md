#  Code signing

## Prérequis

Pour signer une application, la machine dois posséder un certificat Apple Distribution (.cer) avec sa clé privé (.p12) et le provisionning profile du l'app ID.

## Créer un certificat

Ouvrir keychain acces -> Certificat Assisant -> Request Certificat.
Stocker la clé priver dans un endroit sûr car elle ne sera pas regénerer par Apple.
Puis aller dans l'app Store -> Certificat -> Apple Distribution -> etc...
Enfin il est désormais possible de créer les provisionning Profils des bundle ID enregistrer.
