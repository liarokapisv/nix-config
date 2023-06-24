{ config, lib, ... }: {

  options = {
    home.waybar.enable = lib.mkEnableOption "waybar";
  };

  config = lib.mkIf (config.home.waybar.enable) {
    programs.waybar = {
      enable = true;
      systemd.enable = true;
    };
  };

}
