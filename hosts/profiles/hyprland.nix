{ self, pkgs, ... }: {

  programs = {
    hyprland.enable = true;
  };

  # xdg-desktop-portal-hyprland does not provide a FileChooser

  xdg.portal.extraPortals = with pkgs; [
    xdg-desktop-portal-gtk
  ];

  # polkit is required by various programs like gparted

  security.polkit.enable = true;

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

  home-manager.users.${self.user} = {
    imports = [
      ../../homes/profiles/hyprland.nix
    ];
  };

}
