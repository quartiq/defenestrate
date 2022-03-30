{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.memtest86.enable = true;
  nixpkgs.config.allowUnfree = true;

  networking.hostName = "artiq";

  time.timeZone = "Asia/Hong_Kong";

  networking.useDHCP = false;
  networking.interfaces.enp89s0.useDHCP = true;

  services.openssh.enable = true;
  services.openssh.passwordAuthentication = false;

  environment.systemPackages = with pkgs; [ git ];

  users.extraUsers.rabi = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCyPk5WyFoWSvF4ozehxcVBoZ+UHgrI7VW/OoQfFFwIQe0qvetUZBMZwR2FwkLPAMZV8zz1v4EfncudEkVghy4P+/YVLlDjqDq9zwZnh8Nd/ifu84wmcNWHT2UcqnhjniCdshL8a44memzABnxfLLv+sXhP2x32cJAamo5y6fukr2qLp2jbXzR+3sv3klE0ruUXis/BR1lLqNJEYP8jB6fLn2sLKinnZPfn6DwVOk10mGeQsdME/eGl3phpjhODH9JW5V2V5nJBbC0rBnq+78dyArKVqjPSmIcSy72DEIpTctnMEN1W34BGrnsDd5Xd/DKxKxHKTMCHtZRwLC2X0NWN"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCMALVC8RDTHec+PC8y1s3tcpUAODgq6DEzQdHDf/cyvDMfmCaPiMxfIdmkns5lMa03hymIfSmLUF0jFFDc7biRp7uf9AAXNsrTmplHii0l0McuOOZGlSdZM4eL817P7UwJqFMxJyFXDjkubhQiX6kp25Kfuj/zLnupRCaiDvE7ho/xay6Jrv0XLz935TPDwkc7W1asLIvsZLheB+sRz9SMOb9gtrvk5WXZl5JTOFOLu+JaRwQLHL/xdcHJTOod7tqHYfpoC5JHrEwKzbhTOwxZBQBfTQjQktKENQtBxXHTe71rUEWfEZQGg60/BC4BrRmh4qJjlJu3v4VIhC7SSHn1"
    ];
  };
  users.extraUsers.root = {
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCyPk5WyFoWSvF4ozehxcVBoZ+UHgrI7VW/OoQfFFwIQe0qvetUZBMZwR2FwkLPAMZV8zz1v4EfncudEkVghy4P+/YVLlDjqDq9zwZnh8Nd/ifu84wmcNWHT2UcqnhjniCdshL8a44memzABnxfLLv+sXhP2x32cJAamo5y6fukr2qLp2jbXzR+3sv3klE0ruUXis/BR1lLqNJEYP8jB6fLn2sLKinnZPfn6DwVOk10mGeQsdME/eGl3phpjhODH9JW5V2V5nJBbC0rBnq+78dyArKVqjPSmIcSy72DEIpTctnMEN1W34BGrnsDd5Xd/DKxKxHKTMCHtZRwLC2X0NWN"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCMALVC8RDTHec+PC8y1s3tcpUAODgq6DEzQdHDf/cyvDMfmCaPiMxfIdmkns5lMa03hymIfSmLUF0jFFDc7biRp7uf9AAXNsrTmplHii0l0McuOOZGlSdZM4eL817P7UwJqFMxJyFXDjkubhQiX6kp25Kfuj/zLnupRCaiDvE7ho/xay6Jrv0XLz935TPDwkc7W1asLIvsZLheB+sRz9SMOb9gtrvk5WXZl5JTOFOLu+JaRwQLHL/xdcHJTOod7tqHYfpoC5JHrEwKzbhTOwxZBQBfTQjQktKENQtBxXHTe71rUEWfEZQGg60/BC4BrRmh4qJjlJu3v4VIhC7SSHn1"
    ];
  };
  security.sudo.wheelNeedsPassword = false;
  nix.package = pkgs.nix_2_4;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?
}
