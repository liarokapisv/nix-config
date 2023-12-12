{ config, lib, pkgs, ... }: {

  options = {
    dotfiles.nvim.enable = lib.mkEnableOption "nvim";
  };

  config = lib.mkIf (config.dotfiles.nvim.enable)

    {
      programs.neovim = {
        enable = true;

        viAlias = true;
        vimAlias = true;
        vimdiffAlias = true;
        withPython3 = true;

        plugins = with pkgs.vimPlugins;
          [
            fzf-lua
            vim-easymotion
            vim-textobj-user
            vim-textobj-variable-segment
            indentLine
            {
              plugin = nvim-compe;
              type = "lua";
              config = builtins.readFile ./config/compe.lua;
            }
            {
              plugin = nvim-treesitter.withAllGrammars;
              type = "lua";
              config = builtins.readFile ./config/treesitter.lua;
            }
            {
              plugin = kanagawa-nvim;
              type = "lua";
              config = ''
                vim.cmd.colorscheme "kanagawa"
              '';
            }
            {
              plugin = nvim-lspconfig;
              type = "lua";
              config = builtins.readFile ./config/lsp.lua;
              runtime = {
                "lua/lsp_key_mappings.lua".source = ./config/lua/lsp_key_mappings.lua;
                "lua/cursor_hint.lua".source = ./config/lua/cursor_hint.lua;
                "lua/table_merge.lua".source = ./config/lua/table_merge.lua;
              };
            }
          ];

        # Used for aesthetic purposes - adds newline after automatic import of viml config"
        extraLuaConfig = "\n\n";

        extraConfig = builtins.readFile ./config/init.vim;
      };
    };
}
