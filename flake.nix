{
  description = "nix config for miu's homelab monorepo";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
  };

  outputs = { nixpkgs, ... } @ inputs: {
    nixosConfigurations.ditto = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [ ./hosts/ditto ];
    };
  };
}
