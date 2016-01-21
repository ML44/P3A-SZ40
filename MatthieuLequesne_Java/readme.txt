HOWTO
- Placer le texte à chiffrer dans data/nom_du_fichier.txt
- Placer la clé dans data/nom_du_fichier.cle (une position par ligne)
- Lancer "test" avec "nom_du_fichier" comme argument
- La sortie sera dans data/nom_du_fichier_out.txt

NB
- Le document nom_du_ficher.process détaille toutes les étapes du chiffrement.
- L'encodage en Baudot est encore rudimentaire (sans les caractères alphanumériques), il faudra modifier la normalisation pour un encodage plus fidèle du texte d'origine (avec chiffres et ponctuation) et une petite fonction qui traduit la sortie. 