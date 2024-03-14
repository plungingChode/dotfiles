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
          
          # See `man bemenu`
          bemenuDefaults = {
            fn = "FiraCode Nerd Font 14";
            bottom = true;
            hp = 10;
            line-height = 30;
            tb = "#2b303b";
            tf = "#81a1c1";
            fb = "#2b303b";
            ff = "#eceff4";
            sb = "#2b303b";
            sf = "#eceff4";
            nb = "#2b303b";
            nf = "#eceff4";
            ab = "#2b303b";
            af = "#eceff4";
            hb = "#2b303b";
            hf = "#81a1c1" ;
          };

          hyprlandString = s: builtins.replaceStrings ["#"] ["##"] s;

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
