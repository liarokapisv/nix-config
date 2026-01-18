{ self, ... }:
{
  flake.modules.nixos.wayland =
    { pkgs, ... }:
    {
      xdg.portal = {
        enable = true;
        # Install both gtk (default fallback) and gnome (for screencasting) portals
        extraPortals = with pkgs; [
          xdg-desktop-portal-gtk
          xdg-desktop-portal-gnome
        ];
      };

      # polkit is required by various programs like gparted
      security.polkit.enable = true;

      # Enable gnome-keyring for secret service (needed for bitwarden biometrics)
      services.gnome.gnome-keyring.enable = true;
      # Enable gnome-keyring in greetd PAM config
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

    };

  flake.modules.homeManager.wayland =
    { pkgs, lib, ... }:
    {
      imports = [
        self.modules.homeManager.swww
      ];

      programs = {
        swww = {
          enable = true; # Re-enabled - managing wallpapers with swww
          systemd.enable = true;
        };
      };

      home.packages = with pkgs; [ wl-clipboard ];
    };
}
