{ config, pkgs, inputs, ... }:

# uhhh

let
  luaFile = file: "lua << EOF\n${builtins.readFile file}\nEOF\n";
in
{
  nixpkgs.overlays = [
    (final: prev: {
      vimPlugins = prev.vimPlugins // {
        gx-nvim = prev.vimUtils.buildVimPlugin {
          name = "gx.nvim";
          src = inputs.nvim-plugin-gx;
        };

        nvim-dap-vscode-js = prev.vimUtils.buildVimPlugin {
          name = "nvim-dap-vscode-js";
          src = inputs.nvim-plugin-dap-vscode-js;
        };
      };
    })
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    plugins = with pkgs.vimPlugins; [
      # LSP support
      lsp-zero-nvim
      nvim-lspconfig
      nvim-cmp
      cmp-nvim-lsp
      luasnip
      cmp_luasnip
      fidget-nvim
      neodev-nvim

      # Treesitter
      nvim-treesitter-context
      (nvim-treesitter.withPlugins (p: [
        p.tree-sitter-c
        p.tree-sitter-nix
        p.tree-sitter-lua
        p.tree-sitter-python
        p.tree-sitter-rust
        p.tree-sitter-astro
        p.tree-sitter-typescript
        p.tree-sitter-javascript
        p.tree-sitter-vim
        p.tree-sitter-svelte
        p.tree-sitter-html
        p.tree-sitter-css
        p.tree-sitter-tsx
        p.tree-sitter-php
        p.tree-sitter-jsdoc
        p.tree-sitter-sql
        p.tree-sitter-go
        p.tree-sitter-css
        p.tree-sitter-kotlin
        p.tree-sitter-twig
        p.tree-sitter-markdown
        p.tree-sitter-markdown_inline
        p.tree-sitter-bash
        p.tree-sitter-fish
        p.tree-sitter-regex
      ]))

      # Debug adapters
      nvim-dap
      nvim-dap-ui
      nvim-dap-go
      nvim-dap-vscode-js

      nvim-ts-context-commentstring
      vim-fugitive
      gitsigns-nvim
      vim-sleuth

      telescope-nvim
      plenary-nvim
      telescope-fzf-native-nvim
      nvim-surround
      zen-mode-nvim
      undotree
      leap-nvim
      nvim-config-local
      # oil-nvim
      gx-nvim
    ];

    extraLuaConfig = ''
      ${builtins.readFile ./config/lua/util.lua}
      ${builtins.readFile ./config/init.lua}
    '';
  };
  
  home.packages = with pkgs; [
    # Language servers
    nodePackages."@astrojs/language-server"
    nodePackages.svelte-language-server
    gopls
    phpactor
    lua52Packages.lua-lsp
    typescript # tsserver
    vscode-langservers-extracted
    # TODO myPackages.spectral
    prettierd
  ];
  
  # xdg.configFile.nvim.source = 
  #   config.lib.file.mkOutOfStoreSymlink "${config.xdg.configHome}/home-manager/modules/neovim/config";
}
