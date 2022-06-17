{ config, pkgs, artiq, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.memtest86.enable = true;
  hardware.cpu.intel.updateMicrocode = true;
  
  networking.hostName = "artiq";
  networking.networkmanager.enable = true;

  systemd.suppressedSystemUnits = [
    "hibernate.target"
    "suspend.target"
    "suspend-then-hibernate.target"
    "sleep.target"
    "hybrid-sleep.target"
    "systemd-hibernate.service"
    "systemd-hybrid-sleep.service"
    "systemd-suspend.service"
    "systemd-suspend-then-hibernate.service"
  ];

  console.font = "Lat2-Terminus16";
  console.keyMap = "us";
  i18n.defaultLocale = "en_US.UTF-8";

  time.timeZone = "Asia/Hong_Kong";

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    wget
    vim
    gitAndTools.gitFull
    usbutils
    pciutils
    vlc
    file
    lm_sensors
    acpi
    imagemagick
    firefox
    chromium
    (python3.withPackages(ps: with ps; [
      numpy
      scipy
      matplotlib
      jupyter
      pyserial
      spyder
      artiq.packages.x86_64-linux.artiq
    ]))
    artiq.packages.x86_64-linux.openocd-bscanspi
    texlive.combined.scheme-full
    psmisc
    xc3sprog
    gtkwave
    unzip
    zip
    pavucontrol
    rink
    gimp
    gnome3.gnome-tweaks
    libreoffice-fresh
    vscode
  ];
  programs.wireshark.enable = true;
  programs.wireshark.package = pkgs.wireshark;

  hardware.opengl.driSupport = true;

  services.openssh.enable = true;
  services.openssh.passwordAuthentication = false;

  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.package = pkgs.pulseaudioFull;

  services.xserver.enable = true;
  services.xserver.layout = "us";

  services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "rabi";
  # https://github.com/NixOS/nixpkgs/issues/103746
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;
  services.xserver.desktopManager.gnome.enable = true;
  environment.gnome.excludePackages = [ pkgs.epiphany pkgs.gnome3.geary ];

  programs.fish.enable = true;
  programs.command-not-found.enable = false;  # broken with flakes, https://github.com/NixOS/nixpkgs/issues/39789
  users.mutableUsers = true;
  users.defaultUserShell = pkgs.fish;
  users.extraGroups.plugdev = { };
  users.extraUsers.root.initialPassword = "rabi";
  users.extraUsers.rabi = {
    isNormalUser = true;
    extraGroups = ["networkmanager" "wheel" "plugdev" "dialout" "wireshark"];
    initialPassword = "rabi";
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCyPk5WyFoWSvF4ozehxcVBoZ+UHgrI7VW/OoQfFFwIQe0qvetUZBMZwR2FwkLPAMZV8zz1v4EfncudEkVghy4P+/YVLlDjqDq9zwZnh8Nd/ifu84wmcNWHT2UcqnhjniCdshL8a44memzABnxfLLv+sXhP2x32cJAamo5y6fukr2qLp2jbXzR+3sv3klE0ruUXis/BR1lLqNJEYP8jB6fLn2sLKinnZPfn6DwVOk10mGeQsdME/eGl3phpjhODH9JW5V2V5nJBbC0rBnq+78dyArKVqjPSmIcSy72DEIpTctnMEN1W34BGrnsDd5Xd/DKxKxHKTMCHtZRwLC2X0NWN"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCMALVC8RDTHec+PC8y1s3tcpUAODgq6DEzQdHDf/cyvDMfmCaPiMxfIdmkns5lMa03hymIfSmLUF0jFFDc7biRp7uf9AAXNsrTmplHii0l0McuOOZGlSdZM4eL817P7UwJqFMxJyFXDjkubhQiX6kp25Kfuj/zLnupRCaiDvE7ho/xay6Jrv0XLz935TPDwkc7W1asLIvsZLheB+sRz9SMOb9gtrvk5WXZl5JTOFOLu+JaRwQLHL/xdcHJTOod7tqHYfpoC5JHrEwKzbhTOwxZBQBfTQjQktKENQtBxXHTe71rUEWfEZQGg60/BC4BrRmh4qJjlJu3v4VIhC7SSHn1"
    ];
  };
  security.sudo.wheelNeedsPassword = false;
  services.udev.packages = [ artiq.packages.x86_64-linux.openocd-bscanspi ];

  nix.binaryCachePublicKeys = ["nixbld.m-labs.hk-1:5aSRVA5b320xbNvu30tqxVPXpld73bhtOeH6uAjRyHc="];
  nix.binaryCaches = ["https://nixbld.m-labs.hk" "https://cache.nixos.org"];
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
  nix.nixPath = [ "nixpkgs=${pkgs.path}" ];

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "22.05"; # Did you read the comment?
}
