{ self, moduleWithSystem, ... }:
{
  configurations.framework-13-7840u-amd = {
    system = "x86_64-linux";
    modules = [
      (moduleWithSystem (
        { self', system, ... }:
        {
          pkgs,
          lib,
          config,
          ...
        }:
        let
          user = "veritas";
        in
        {
          imports = [
            self.modules.nixos.framework-13-7840u-amd
            self.modules.nixos.power
            self.modules.nixos.pipewire
            self.modules.nixos.bluetooth
            self.modules.nixos.hyprland
            self.modules.nixos.usb-automount
            self.modules.nixos.networking
            self.modules.nixos.virtualisation
            self.modules.nixos.realsense
            self.modules.nixos.embedded
            self.modules.nixos.bws
            self.modules.nixos.plocate
            self.modules.nixos.styling
          ];

          services.bws = {
            refresh = "10s";
            enable = true;
            secrets.test.id = "8ba4f067-d3f4-4431-b316-b39d01361b04";
          };

          networking.firewall = {
            trustedInterfaces = [
              "enp195s0f3u1c2"
            ];
            logRefusedConnections = true;
          };

          virtualisation.docker.daemon.settings = {
            "data-root" = "/home/docker-root";
          };
          nix = {
            settings = {
              substituters = [
                "https://ros.cachix.org/"
              ];
              trusted-public-keys = [
                "ros.cachix.org-1:dSyZxI8geDCJrwgvCOHDoAfOm5sV1wCPjBkKL+38Rvo="
              ];
            };
          };

          environment.systemPackages = [
            # this needs to be installed system-wide for polkit integration..
            pkgs.bitwarden-desktop
          ];

          # netbird
          services.netbird = {
            enable = true;
            clients.default = {
              hardened = false;
              config.ServerSSHAllowed = true;
              environment.NB_LOG_LEVEL = lib.mkForce "trace";
            };
          };

          services = {
            teamviewer.enable = true;
            fwupd.enable = true;
            greetd = {
              enable = true;
              settings = {
                default_session = {
                  command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd Hyprland";
                  user = "greeter";
                };
              };
            };
          };

          boot.loader.systemd-boot.enable = true;
          boot.loader.efi.canTouchEfiVariables = false;
          boot.tmp.useTmpfs = true;

          networking.hostName = "veritas-framework-13-amd-7840u";

          users.users.${user} = {
            isNormalUser = true;
            uid = 1000;
            extraGroups = [
              "wheel"
              "dialout"
            ]
            ++ config.services.plocate.requiredGroups
            ++ config.services.pipewire.requiredGroups
            ++ config.virtualisation.requiredGroups;
            initialHashedPassword = "$6$JwTimdf683A1QxN.$aorlpRJPWrcsl0pR1nlELJhdy8traiVPBXnwXU5IfEbWBD5PusIrkjRZDA76OJECmJdR9PLiUyxJeQUzjX6Nv0";

            shell = pkgs.zsh;

            openssh.authorizedKeys.keys = [
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDHQE3nquLEwnEU5NdU1YZ1LBLCIq4gaLgMF+TvnL9vV veritas@veritas"
            ];
          };

          programs = {
            steam.enable = true;
            wireshark = {
              enable = true;
              usbmon.enable = true;
            };
          };

          stylix.image = "${self.outPath}/images/mountain-music.gif";

          home-manager.users.${user} = {
            imports = [
              self.modules.homeManager.base
              self.modules.homeManager.realsense
              self.modules.homeManager.networking
              self.modules.homeManager.bluetooth
              self.modules.homeManager.embedded
              self.modules.homeManager.pipewire
              self.modules.homeManager.hyprland
              self.modules.homeManager.configs
              self.modules.homeManager.styling
            ];

            home = {
              packages = with pkgs; [
                self'.packages.dynamixel-wizard-2
                qbittorrent
                vlc
                digikam
                anydesk
                slack
                discord
                teams-for-linux
                zoom-us
                self'.packages.erae-lab
                signal-desktop
                obsidian
                teamviewer
                self'.packages.stremio-linux-shell
                google-chrome
                viber
              ];

              stateVersion = "24.05";
            };

          };

          fonts = {
            enableDefaultPackages = true;
          };

          system.stateVersion = "24.05";
        }
      ))
    ];
  };
}
