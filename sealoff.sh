#!/bin/sh

set -e
nixos-rebuild boot
nix-collect-garbage -d
