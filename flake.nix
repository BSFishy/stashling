{
  inputs = {
    # TODO: switch to "github:nixos/nixpkgs/nixos-unstable" when
    # https://github.com/NixOS/nixpkgs/issues/456753 is fixed
    nixpkgs.url = "github:nixos/nixpkgs/05e7859cd78afdd7b8b4c42d291de521013d35ee";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        # TODO: switch to upstream bundix when
        # https://github.com/nix-community/bundix/pull/122 is merged
        bundix = pkgs.callPackage (builtins.fetchGit {
          url = "https://github.com/BSFishy/bundix.git";
          rev = "9788ff1b7de12f963bfaefae1fd27ee41acfd5cb";
        }) { };

        overlays = [
          (self: super: {
            ruby = pkgs.ruby_3_4;
          })
        ];

        pkgs = import nixpkgs { inherit overlays system; };

        rubyEnv = pkgs.bundlerEnv {
          name = "rails-env";
          inherit (pkgs) ruby;
          gemdir = ./.;
        };

        updateDeps = pkgs.writeScriptBin "update-deps" (
          builtins.readFile (
            pkgs.replaceVars ./bin/update {
              bundix = "${bundix}/bin/bundix";
              bundler = "${pkgs.bundler}/bin/bundler";
            }
          )
        );
      in
      {
        devShells = {
          default = pkgs.mkShell {
            buildInputs = [
              rubyEnv
              rubyEnv.wrappedRuby
              updateDeps
            ];
          };
        };
      }
    );
}
