{
  description = "SimpleX Chat terminal client from the official prebuilt binary, updated daily";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    { nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      packages.${system} = rec {
        simplex-chat = pkgs.callPackage ./package.nix { };
        default = simplex-chat;
      };
    };
}
