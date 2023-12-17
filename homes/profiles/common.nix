{ self, config, pkgs, ... }: {

  imports = [
    ../../modules/home-manager
    ../../configs/home-manager
    self.inputs.stylix.homeManagerModules.stylix
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
        warn_timeout = "1000h";
      };
    };
    fzf.enable = true;
    kitty = {
      enable = true;
      settings = {
        enable_audio_bell = false;
        confirm_on_os_window_close = true;
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

    zathura = {
      enable = true;
      mappings = {
        "<Space>" = "navigate next";
        "<S-Space>" = "navigate previous";
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
      conan
    ];
  };
}
