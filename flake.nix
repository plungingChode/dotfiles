{
  description = "Home Manager configuration of chode";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-23.11";
    };
    nixpkgsUnstable = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvim-plugin-dap-vscode-js = {
      url = "github:mxsdev/nvim-dap-vscode-js";
      flake = false;
    };
    nvim-plugin-gx = {
      url = "github:chrishrb/gx.nvim";
      flake = false;
    };
  };

  outputs = { nixpkgs, nixpkgsUnstable, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      unstable = nixpkgsUnstable.legacyPackages.${system};
    in {
      homeConfigurations."chode" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [ ./home.nix ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
        extraSpecialArgs = {
          # https://www.reddit.com/r/NixOS/comments/12ewa4j
          inherit unstable;
          inherit inputs;
          
          attrsToCliArgs = attrs: 
            let 
              mapAttr = (name: value: 
                if builtins.isBool value then
                  "--${name}"
                else if builtins.isString value || builtins.isPath value then
                  "--${name} '${value}'"
                else
                  "--${name} ${builtins.toString value}"
              );
          in 
            builtins.toString (pkgs.lib.mapAttrsToList mapAttr attrs);
        };
      };
    };
}
