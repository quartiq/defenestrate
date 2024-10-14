{ config, pkgs, artiq, ... }:

let
  sealOff = pkgs.writeShellScriptBin "seal-off"
  ''
  set -e
  nixos-rebuild boot
  nix-collect-garbage -d
  '';

in {
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.memtest86.enable = true;
  boot.kernelParams = ["intel_idle.max_cstate=1"];
  boot.kernelPackages = pkgs.linuxPackages_latest;
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

  time.timeZone = "UTC";

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    sealOff
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
    (artiq.inputs.nixpkgs.legacyPackages.x86_64-linux.python3.withPackages(ps: with ps; [
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
    vscodium
  ];
  programs.wireshark.enable = true;
  programs.wireshark.package = pkgs.wireshark;

  hardware.opengl.driSupport = true;

  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = false;

  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.package = pkgs.pulseaudioFull;

  services.xserver.enable = true;
  services.xserver.xkb.layout = "us";

  services.xserver.displayManager.gdm.enable = true;
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "rabi";
  # https://github.com/NixOS/nixpkgs/issues/103746
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;
  services.xserver.desktopManager.gnome.enable = true;
  environment.gnome.excludePackages = [ pkgs.epiphany ];

  programs.fish.enable = true;
  programs.command-not-found.enable = false;  # broken with flakes, https://github.com/NixOS/nixpkgs/issues/39789
  users.mutableUsers = true;
  users.defaultUserShell = pkgs.fish;
  users.users.root.initialPassword = "rabi";
  users.extraGroups.plugdev = { };
  users.extraUsers.rabi = {
    isNormalUser = true;
    extraGroups = ["networkmanager" "wheel" "plugdev" "dialout" "wireshark"];
    initialPassword = "rabi";
    openssh.authorizedKeys.keys = [
      # m-labs
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCyPk5WyFoWSvF4ozehxcVBoZ+UHgrI7VW/OoQfFFwIQe0qvetUZBMZwR2FwkLPAMZV8zz1v4EfncudEkVghy4P+/YVLlDjqDq9zwZnh8Nd/ifu84wmcNWHT2UcqnhjniCdshL8a44memzABnxfLLv+sXhP2x32cJAamo5y6fukr2qLp2jbXzR+3sv3klE0ruUXis/BR1lLqNJEYP8jB6fLn2sLKinnZPfn6DwVOk10mGeQsdME/eGl3phpjhODH9JW5V2V5nJBbC0rBnq+78dyArKVqjPSmIcSy72DEIpTctnMEN1W34BGrnsDd5Xd/DKxKxHKTMCHtZRwLC2X0NWN"
      # m-labs
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCMALVC8RDTHec+PC8y1s3tcpUAODgq6DEzQdHDf/cyvDMfmCaPiMxfIdmkns5lMa03hymIfSmLUF0jFFDc7biRp7uf9AAXNsrTmplHii0l0McuOOZGlSdZM4eL817P7UwJqFMxJyFXDjkubhQiX6kp25Kfuj/zLnupRCaiDvE7ho/xay6Jrv0XLz935TPDwkc7W1asLIvsZLheB+sRz9SMOb9gtrvk5WXZl5JTOFOLu+JaRwQLHL/xdcHJTOod7tqHYfpoC5JHrEwKzbhTOwxZBQBfTQjQktKENQtBxXHTe71rUEWfEZQGg60/BC4BrRmh4qJjlJu3v4VIhC7SSHn1"
      # quartiq rj
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC27krR8G8Pb59YuYm7+X2mmNnVdk/t9myYgO8LH0zfb2MeeXX5+90nW9kMjKflJss/oLl8dkD85jbJ0fRbRkfJd20pGCqCUuYAbYKkowigFVEkbrbWSLkmf+clRjzJOuBuUA0uq0XKS17uMC3qhu+dDdBOAIKb3L83NfVE8p8Pjb4BPktQrdxefM43/x4jTMuc7tgxVmTOEge3+rmVPK2GnLkUBgBn8b6S+9ElPd63HXI5J5f61v21l5N9V0mhTu1pv6PiDRdFIlFDK9dLVZcZ2qlzpKmCnFrOoreBEgre44SpfFe5/MMItxvWiVsj/rij/rHZZiol1k7JiQCnEHeCCbjjvcBBka5HxZgcb3vBZVceTOawrmjbdbA2dq35sUptz/bEgdZ1UVCmVpWsdROAlEDBmSSbcVwxzcvhoKnkpbuP4Q0V3tVKSLW053ADFNB4frtwY5nAZfsVErFLLphjwb8nlyJoDRNapQrn5syEiW0ligX2AAskZTYIl2A5AYyWPrmX6HJOPqZGatMU3qQiRMxs+hFqhyyCmBgl0kcsgW09MBKtJWk1Fbii98MHqgRUN9R7AUiYy5p78Pnv9DC8DT8Ubl9zoP0g5d40P9NGK2LAhMxLXvtckJ4ERqbSEcNZJw+q4jBrOHnMTz+NLdAUiEtru+6T2OdhaHv+eiNlFQ=="
      # quartiq rj
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMUaB2G1jexxfkdlly3fdWslH54/s/bOuvk9AxqpjtAY"
      # quartiq pk
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIu6yhjCoZ62eamYrAXtFefDhplTRUIdD4tncwlkyAEH"
    ];
  };
  security.sudo.wheelNeedsPassword = false;
  services.udev.packages = [ artiq.packages.x86_64-linux.openocd-bscanspi ];

  nix.settings.trusted-public-keys = ["nixbld.m-labs.hk-1:5aSRVA5b320xbNvu30tqxVPXpld73bhtOeH6uAjRyHc="];
  nix.settings.substituters = ["https://nixbld.m-labs.hk"];
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
  nix.nixPath = [ "nixpkgs=${pkgs.path}" ];

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "24.05"; # Did you read the comment?
}
