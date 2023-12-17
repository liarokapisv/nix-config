{ self, config, pkgs, ... }: {

  imports = [
    self.inputs.stylix.homeManagerModules.stylix
    ./dotfiles
    ./programs
  ];

  nixpkgs.config.allowUnfree = true;

  systemd.user.startServices = true;

  fonts = {
    # enables font autodiscovery
    fontconfig.enable = true;
  };

  stylix = {
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

  programs = {
    home-manager.enable = true;
    neovim.enable = true;
    zsh.enable = true;
    ssh.enable = true;
    firefox.enable = true;
    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
      config = {
        warn_timeout = "1m";
      };
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
        http = {
          postBuffer = 52428800;
        };
      };
    };
    swww = {
      systemd = {
        exec-img = "${config.stylix.image}";
      };
    };

  };

  home = {
    packages = with pkgs; [
      ripgrep
      tree
      vmpk
      stremio
      reaper
      segger-jlink
      stm32cubemx
    ];
  };
}
