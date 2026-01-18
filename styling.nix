{ self, ... }:
let
  commonStylixConfig =
    { config, pkgs }:
    {
      enable = true;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/kanagawa.yaml";
      polarity = "dark";
      fonts = {
        serif = config.stylix.fonts.monospace;
        sansSerif = config.stylix.fonts.monospace;
        emoji = config.stylix.fonts.monospace;
      };
      opacity = {
        terminal = 0.85;
      };
    };
in
{
  flake-file.inputs.stylix = {
    url = "github:danth/stylix";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  flake.modules.nixos.styling =
    { config, pkgs, ... }:
    {
      imports = [ self.inputs.stylix.nixosModules.stylix ];
      stylix = commonStylixConfig { inherit config pkgs; };
    };

  flake.modules.homeManager.styling =
    {
      osConfig,
      config,
      pkgs,
      lib,
      ...
    }:
    {
      imports = lib.optionals (!osConfig ? stylix) [ self.inputs.stylix.homeModules.stylix ];

      stylix = lib.mkMerge [
        (lib.mkIf (!osConfig ? stylix) (commonStylixConfig {
          inherit config pkgs;
        }))
        {
          targets = {
            vim.enable = false;
            firefox.profileNames = [ "default" ];
          };
        }
      ];

      home.pointerCursor = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Classic";
        size = 16;
      };

      programs = {
        swww = {
          systemd = {
            exec-img = "${config.stylix.image}";
          };
        };

        zsh = {
          initContent = ''
            ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#${config.stylix.generated.palette.base04},dim"
          '';
        };

        neovim = {
          plugins = with pkgs.vimPlugins; [
            {
              plugin = kanagawa-nvim;
              type = "lua";
              config = ''
                vim.cmd.colorscheme "kanagawa"
              '';
            }
          ];
        };
      };

      fonts = {
        # enables font autodiscovery
        fontconfig.enable = true;
      };

      gtk = {
        iconTheme = {
          package = pkgs.adwaita-icon-theme;
          name = "Adwaita";
        };
      };

      home.file."Pictures/Wallpapers" = {
        source = "${self.outPath}/images";
      };

    };
}
