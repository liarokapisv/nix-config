{ self, config, pkgs, ... }: {

  imports = [
    self.inputs.stylix.homeManagerModules.stylix
    self.inputs.nur.hmModules.nur
    ./nvim
    ./zsh
    ./development
    ./hyprland
    ./waybar
    ./fuzzel
    ./ssh
    ./firefox
  ];

  nixpkgs.config.allowUnfree = true;

  stylix = {
    image = ./images/asian-neon-night.jpg;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/kanagawa.yaml";
    polarity = "dark";
    fonts = {
      serif = config.stylix.fonts.monospace;
      sansSerif = config.stylix.fonts.monospace;
      emoji = config.stylix.fonts.monospace;
    };
    opacity = {
      applications = 0.90;
      terminal = 0.85;
    };
    targets = {
      vim.enable = false;
    };
  };

  home.stateVersion = "23.05";

  home.packages = with pkgs; [
    tree
    vmpk
    stremio
    spotify
    reaper
    discord
    viber
    segger-jlink
    eagle
    stm32cubemx
  ];

  systemd.user.startServices = true;

  fonts = {
    # enables font autodiscovery
    fontconfig.enable = true;
  };

  programs = {
    home-manager.enable = true;
    ssh.enable = true;
    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
    fzf.enable = true;
    kitty = {
      enable = true;
      settings = {
        enable_audio_bell = false;
      };
    };

    git = {
      enable = true;
      extraConfig = {
        init = {
          defaultBranch = "main";
        };
        user = {
          name = "Alexandros Liarokapis";
          email = "liarokapis.v@gmail.com";
        };
      };
    };
  };

  home = {
    nvim.enable = true;
    zsh.enable = true;
    development = {
      nix.enable = true;
    };
    ssh.enable = true;
    firefox.enable = true;
  };
}
