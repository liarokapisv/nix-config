{ self, pkgs, ... }: {

  sound.enable = true;

  services = {
    pipewire = {
      enable = true;
      alsa.enable = true;
      jack.enable = true;
      pulse.enable = true;
    };
  };

  home-manager.users.${self.user} = {

    wayland.windowManager.hyprland.ext.keybinds.wireplumber.enable = true;
    programs.waybar.ext.wireplumber.on-click = "${pkgs.helvum}/bin/helvum";

    home.packages = with pkgs; [
      alsa-utils
      pavucontrol
      helvum
    ];
  };
}

