{ self, ... }:
{
  flake.modules.nixos.wayland =
    { pkgs, ... }:
    {
      xdg.portal = {
        enable = true;
        # Install both gtk (default) and gnome (ONLY for screencasting) portals
        # GTK handles FileChooser, Settings, Notifications, etc.
        # GNOME handles ScreenCast (only implementation available for Niri)
        extraPortals = with pkgs; [
          xdg-desktop-portal-gtk
          xdg-desktop-portal-gnome
        ];
      };

      # polkit is required by various programs like gparted
      security.polkit.enable = true;

      # Allow NetworkManager modifications without authentication for wheel users
      # This prevents authentication spam when switching networks in DMS network widget.
      # DMS runs `nmcli connection modify` on ALL saved connections (34+) when changing
      # network preference, which triggers multiple stacked polkit authentication dialogs.
      # See: DMS LegacyNetworkService.qml setConnectionPriority() function
      security.polkit.extraConfig = ''
        polkit.addRule(function(action, subject) {
          if (action.id == "org.freedesktop.NetworkManager.settings.modify.system" &&
              subject.isInGroup("wheel")) {
            return polkit.Result.YES;
          }
        });
      '';

      # Enable gnome-keyring for secret service (needed for bitwarden biometrics)
      services.gnome.gnome-keyring.enable = true;
      # Enable gnome-keyring in PAM config
      security.pam.services = {
        greetd.enableGnomeKeyring = true;
        login.enableGnomeKeyring = true;
        passwd.enableGnomeKeyring = true;
      };

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
