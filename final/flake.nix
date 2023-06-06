{
  inputs.nixpkgs.url = github:NixOS/nixpkgs/nixos-23.05;
  inputs.artiq.url = git+https://github.com/m-labs/artiq.git?ref=release-7;
  outputs = { self, nixpkgs, artiq }: {
    nixosConfigurations.artiq = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit artiq; };
      modules = [ ./configuration.nix ];
    };
  };
}
