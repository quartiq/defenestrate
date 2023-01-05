{
  inputs.artiq.url = git+https://github.com/m-labs/artiq.git?ref=release-7;
  outputs = { self, artiq }: {
    nixosConfigurations.artiq = artiq.inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit artiq; };
      modules = [ ./configuration.nix ];
    };
  };
}
