{ pkgs, ... }:
{
  programs.neovim = {
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withPython3 = true;

    plugins = with pkgs.vimPlugins; [
      {
        plugin = fzf-lua;
        type = "lua";
        config = builtins.readFile ./fzf.lua;
        runtime = {
          "lua/utils.lua".source = ./lua/utils.lua;
        };
      }
      vim-easymotion
      vim-textobj-user
      vim-easy-align
      vim-textobj-variable-segment
      {
        plugin = text-case-nvim;
        type = "lua";
        config = "require('textcase').setup()";
      }
      indentLine
      {
        plugin = nvim-cmp;
        type = "lua";
        config = builtins.readFile ./cmp.lua;
      }

      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp-cmdline

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

      {
        plugin = tailwind-tools-nvim;
        type = "lua";
        config = "require('tailwind-tools').setup()";
      }

      {
        plugin = (
          pkgs.vimUtils.buildVimPlugin {
            pname = "nvim-tmux-navigation";
            version = "4898c98";
            src = pkgs.fetchFromGitHub {
              owner = "alexghergh";
              repo = "nvim-tmux-navigation";
              rev = "4898c98702954439233fdaf764c39636681e2861";
              hash = "sha256-CxAgQSbOrg/SsQXupwCv8cyZXIB7tkWO+Y6FDtoR8xk=";
            };
            meta.homepage = "https://github.com/alexghergh/nvim-tmux-navigation";
          }
        );
        type = "lua";
        config = ''
          local nvim_tmux_nav = require('nvim-tmux-navigation')

          nvim_tmux_nav.setup {
              disable_when_zoomed = true,
              keybindings = {
                  left = "<C-h>",
                  down = "<C-j>",
                  up = "<C-k>",
                  right = "<C-l>",
                  next = "<C-Space>",
              }
          }
        '';
      }

      {
        plugin = oil-nvim;
        type = "lua";
        config = builtins.readFile ./oil.lua;
      }

      {
        plugin = lualine-nvim;
        type = "lua";
        config = "require('lualine').setup()";
      }

      (pkgs.vimUtils.buildVimPlugin {
        name = "cwatchfile";
        src = ./cwatchfile;
      })

    ];

    extraLuaConfig = builtins.readFile ./init.lua;
  };
}
