FILE DESCRIPTIONS

Folder objects
    Chaque fichier est pour un objet. Il contient:
        1. Les structures abstraites et sous-structures.
        2. Un constructeur internes.
        3. Les constructeurs externes, avec un nom de fonction différent de l'objet.

Folder data_base
    Chaque fichier est pour une différente liste de données, souvent des objets.

Folder examples
    Chaque fichier est une série de function calls qui simulent une partie.
    Ces fichiers peuvent être lancés directement après avoir lancé main.jl.

Folder source
    Contient le code source:
    player_actions
        Contient les fonctions de premier niveau. Fonctions appelées directement par l'utilisateur pour jouer.
        Débutent toutes par « global g » et par une vérification que l'action est légale et finissent toutes par return.
    short_auto_actions
        Contient des fonctions de second niveau de 7 lignes au moins, ainsi que les raccourcis. Fonctions fermées à l'utilisateur.
    long_auto_actions
        Contient des fonctions de second niveau plus longues. Fonctions fermées à l'utilisateur.
    auto_step_actions
        Contient les fonctions de second niveau relatives aux tours de jeux. Fonctions fermées à l'utilisateur
    show
        Contient des extensions de la fonction show, ouvertes à l'utilisateur. Doit inclure « global g » et return.

main
    Lance le jeu.


HOW TO PLAY

Conçu comme si le jeu aura une interface graphique ou les joueurs cliquent sur l'écran. Ces clics sont des appels de fonctions.
Donc en attendant, le jeu est entièrement joué en appelant des fonctions.