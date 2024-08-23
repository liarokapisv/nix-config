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
      ];

    # Used for aesthetic purposes - adds newline after automatic import of viml config"
    extraLuaConfig = "\n\n";

    extraConfig = builtins.readFile ./init.vim;
  };
}
