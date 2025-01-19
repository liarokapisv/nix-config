{ self, config, pkgs, ... }: {

  imports = [ self.inputs.stylix.homeManagerModules.stylix ];

  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/kanagawa.yaml";
    polarity = "dark";
    fonts = {
      serif = config.stylix.fonts.monospace;
      sansSerif = config.stylix.fonts.monospace;
      emoji = config.stylix.fonts.monospace;
    };
    opacity = {
      applications = 0.9;
      terminal = 0.85;
    };
    targets = { vim.enable = false; };
  };

  programs = {
    swww = { systemd = { exec-img = "${config.stylix.image}"; }; };

    neovim = {
      plugins = with pkgs.vimPlugins; [{
        plugin = kanagawa-nvim;
        type = "lua";
        config = ''
          vim.cmd.colorscheme "kanagawa"
        '';
      }];
    };
  };

  fonts = {
    # enables font autodiscovery
    fontconfig.enable = true;
  };

}
