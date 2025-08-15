#!/usr/bin/env bash

echo "Asking for sudo credentials"
sudo -v

echo "Clearing home manager profile history"
nix profile wipe-history --profile ~/.local/state/nix/profiles/home-manager

echo "Clearing system profile history"
sudo nix profile wipe-history --profile /nix/var/nix/profiles/system

echo "Running Nix store garbage collect"
nix store gc
