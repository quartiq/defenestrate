{
  inputs.artiq.url = git+https://github.com/m-labs/artiq.git;
  outputs = { self, artiq }: {
    nixosConfigurations.artiq = artiq.inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit artiq; };
      modules = [ ./configuration.nix ];
    };
  };
}
