{ pkgs, ... }: {

  programs.neovim = {
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withPython3 = true;

    extraPackages = with pkgs; [
      nil
      nixpkgs-fmt
    ];

    plugins = with pkgs.vimPlugins;
      [
        fzf-lua
        vim-easymotion
        vim-textobj-user
        vim-easy-align
        vim-textobj-variable-segment
        {
          plugin = text-case-nvim;
          type = "lua";
          config = ''
            require('textcase').setup {}
          '';
        }
        indentLine
        {
          plugin = nvim-compe;
          type = "lua";
          config = builtins.readFile ./compe.lua;
        }
        # TODO: update when cmp plays better with nightly rust-analyzer
        # cmp-nvim-lsp
        # cmp-buffer
        # cmp-path
        # cmp-cmdline
        # {
        #   plugin = nvim-cmp;
        #   type = "lua";
        #   config = builtins.readFile ./cmp.lua;
        # }
        {
          plugin = nvim-treesitter.withAllGrammars;
          type = "lua";
          config = builtins.readFile ./treesitter.lua;
        }
        {
          plugin = nvim-lspconfig;
          type = "lua";
          config = builtins.readFile ./lsp.lua;
          runtime = {
            "lua/lsp_key_mappings.lua".source = ./lua/lsp_key_mappings.lua;
            "lua/cursor_hint.lua".source = ./lua/cursor_hint.lua;
            "lua/table_merge.lua".source = ./lua/table_merge.lua;
          };
        }
        # used for tailwind-css-inline hints: no need to setup on nvim-lspconfig
        {
          # TODO: use upstream version after nixpkgs version update
          plugin = (pkgs.vimUtils.buildVimPlugin
            {
              pname = "tailwind-tools.nvim";
              version = "2024-09-26";
              src = pkgs.fetchFromGitHub {
                owner = "luckasRanarison";
                repo = "tailwind-tools.nvim";
                rev = "4b2d88cc7d49a92f28b9942712f1a53d2c3d5b27";
                sha256 = "05mnbrzfsrkxnv9fz3f0bzwrw833rgcvj0wxgf8pvjjvdjnpl1ax";
              };
              meta.homepage = "https://github.com/luckasRanarison/tailwind-tools.nvim/";
            });
          type = "lua";
          config = ''
            require("tailwind-tools").setup({
              -- your configuration
            })
          '';
        }

      ];

    # Used for aesthetic purposes - adds newline after automatic import of viml config"
    extraLuaConfig = "\n\n";

    extraConfig = builtins.readFile ./init.vim;
  };
}
