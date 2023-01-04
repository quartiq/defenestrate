{
  inputs.artiq.url = git+https://github.com/m-labs/artiq.git?ref=release-7;
  outputs = { self, artiq }: {
    nixosConfigurations.artiq = artiq.inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      # Do not use specialArgs to pass the ARTIQ flake - this evaluates many attributes
      # and bloats the installation. https://git.m-labs.hk/M-Labs/defenestrate/issues/1
      modules = [ ( import ./configuration.nix { inherit artiq; } ) ];
    };
  };
}
