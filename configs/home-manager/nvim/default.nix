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
        vim-textobj-variable-segment
        indentLine
        {
          plugin = nvim-compe;
          type = "lua";
          config = builtins.readFile ./compe.lua;
        }
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
