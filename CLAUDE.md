# Fleet — Principes de configuration

## Idéologie : minimalisme

Chaque configuration doit faire exactement ce dont la machine a besoin, rien de plus.

- Pas de paquets installés par précaution
- Pas de services activés sans usage concret
- Pas d'abstraction prématurée dans les modules Nix
- Préférer la lisibilité à la généricité

## NixOS : stable LTS

Toutes les machines de la flotte tournent sur le channel NixOS stable LTS.
Éviter les packages ou options disponibles uniquement sur nixos-unstable.

## Design system : Everforest

Toutes les machines de la flotte sont configurées autour du thème Everforest.
Couleurs, terminaux, barres de statut, éditeurs et gestionnaires de fenêtres doivent s'y conformer.
