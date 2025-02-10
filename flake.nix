{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";

    nixvim.url = "github:nix-community/nixvim";
    snowfall-lib.url = "github:snowfallorg/lib";
    wgsl-analyzer.url = "github:wgsl-analyzer/wgsl-analyzer";
  };

  outputs = inputs:
    inputs.snowfall-lib.mkFlake {
      inherit inputs;

      src = ./.;

      snowfall = {
        namespace = "teevik";
      };

      channels-config.allowUnfree = true;

      alias.packages.default = "neovim";
    };
}
