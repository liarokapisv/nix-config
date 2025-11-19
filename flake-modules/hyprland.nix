{ self, ... }:
{
  flake.modules.nixos.hyprland =
    { config, pkgs, ... }:
    {

      programs = {
        hyprland.enable = true;
      };

      # xdg-desktop-portal-hyprland does not provide a FileChooser
      xdg.portal = {
        enable = true;
        extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
        config.hyprland.default = [
          "hyprland"
          "gtk"
        ];
      };

      # polkit is required by various programs like gparted
      security.polkit.enable = true;

      # Enable gnome-keyring for secret service (needed for bitwarden biometrics)
      services.gnome.gnome-keyring.enable = true;
      security.pam.services.greetd.enableGnomeKeyring = true;

      systemd = {
        user.services.polkit-gnome-authentication-agent-1 = {
          description = "polkit-gnome-authentication-agent-1";
          wantedBy = [ "graphical-session.target" ];
          wants = [ "graphical-session.target" ];
          after = [ "graphical-session.target" ];
          serviceConfig = {
            Type = "simple";
            ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
            Restart = "on-failure";
            RestartSec = 1;
            TimeoutStopSec = 10;
          };
        };
      };

      home-manager.users.${config.user} = {
        imports = [
          self.modules.homeManager.hyprland
        ];
      };

    };

  flake.modules.homeManager.hyprland =
    { pkgs, lib, ... }:
    {
      imports = [
        self.modules.homeManager.swww
      ];

      wayland.windowManager.hyprland.enable = true;

      xdg.portal = {
        enable = true;
        extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
        config.hyprland.default = [
          "hyprland"
          "gtk"
        ];
      };

      programs = {
        fuzzel.enable = true;
        swww = {
          enable = true;
          systemd.enable = true;
        };
        waybar = {
          enable = true;
          systemd.enable = true;
        };
      };

      services = {
        hyprpaper.enable = lib.mkForce false;
        dunst.enable = true;
      };

      home.packages = with pkgs; [ wl-clipboard ];

    };
}
