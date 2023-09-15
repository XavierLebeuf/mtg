TO DO: finir strike it rich, make non mana activated ability go through stack.

FILE DESCRIPTIONS

Folder objects
    Chaque fichier est pour un objet. Il contient:
        1. Les structures abstraites et sous-structures.
        2. Un constructeur internes.
        3. Les constructeurs externes, avec un nom de fonction différent de l'objet.
        4. Des fonctions raccroucis, fermées à l'utilisateur.
        5. Des extensions de la fonction show, ouvertes à l'utilisateur. Donc inclure « global g ».

Folder data_base
    Chaque fichier est pour une différente liste de données, souvent des objets.

Folder examples
    Chaque fichier est une série de function calls qui simulent une partie.
    Ces fichiers peuvent être lancés directement après avoir lancé main.jl.

player_actions
    Contient les fonctions de premier niveau. Fonctions appelées directement par l'utilisateur pour jouer.
    Débutent toutes par « global g » et par une vérification que l'action est légale et finissent toutes par return.

auto_actions
    Contient les fonctions de second niveau. Fonctions fermées à l'utilisateur.

main
    Lance le jeu.


HOW TO PLAY

Conçu comme si le jeu aura une interface graphique ou les joueurs cliquent sur l'écran. Ces clics sont des appels de fonctions.
Donc en attendant, le jeu est entièrement joué en appelant des fonctions.