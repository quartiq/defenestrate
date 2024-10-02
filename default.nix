let
  pkgs = import <nixpkgs> {};

  # copied from nixpkgs/nixos/release.nix. Unfortunately, this isn't exported.
  makeNetboot = { modules, system, ... }:
    let
      configEvaled = import <nixpkgs/nixos/lib/eval-config.nix> {
        inherit system modules;
      };
      build = configEvaled.config.system.build;
      kernelTarget = configEvaled.pkgs.stdenv.hostPlatform.linux-kernel.target;
    in
      pkgs.symlinkJoin {
        name = "netboot";
        paths = [
          build.netbootRamdisk
          build.kernel
          build.netbootIpxeScript
        ];
        postBuild = ''
          mkdir -p $out/nix-support
          echo "file ${kernelTarget} ${build.kernel}/${kernelTarget}" >> $out/nix-support/hydra-build-products
          echo "file initrd ${build.netbootRamdisk}/initrd" >> $out/nix-support/hydra-build-products
          echo "file ipxe ${build.netbootIpxeScript}/netboot.ipxe" >> $out/nix-support/hydra-build-products
        '';
        preferLocalBuild = true;
      };
  
  autoInstall = pkgs.writeShellScriptBin "auto-install"
    ''
    set -e
    parted /dev/nvme0n1 -- mklabel gpt
    parted /dev/nvme0n1 -- mkpart primary 512MiB 100%
    parted /dev/nvme0n1 -- mkpart ESP fat32 1MiB 512MiB
    parted /dev/nvme0n1 -- set 2 esp on
    mkfs.btrfs -f -L nixos /dev/nvme0n1p1
    mkfs.fat -F 32 -n boot /dev/nvme0n1p2
    mount /dev/disk/by-label/nixos /mnt
    mkdir -p /mnt/boot
    mount /dev/disk/by-label/boot /mnt/boot
    nixos-generate-config --root /mnt
    cp ${./final}/* /mnt/etc/nixos
    nixos-install --no-root-password --flake /mnt/etc/nixos#artiq
    reboot
    ''; 

  customModule = {
    # system.stateVersion = "24.05";
    environment.systemPackages = [ autoInstall pkgs.git ];
    documentation.info.enable = false; # https://github.com/NixOS/nixpkgs/issues/124215
    documentation.man.enable = false;
    nix.settings.trusted-public-keys = ["nixbld.m-labs.hk-1:5aSRVA5b320xbNvu30tqxVPXpld73bhtOeH6uAjRyHc="];
    nix.settings.substituters = ["https://nixbld.m-labs.hk"];
  };

in
  makeNetboot {
    modules = [
      <nixpkgs/nixos/modules/installer/netboot/netboot-minimal.nix>
      customModule
    ];
    system = "x86_64-linux";
  }
