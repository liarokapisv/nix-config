{ config, lib, ... }: {

  options = {
    home.ssh.enable = lib.mkEnableOption "ssh";
  };

  config = lib.mkIf (config.home.ssh.enable) {
    programs = {
      ssh = {
        enable = true;
        extraConfig = builtins.readFile ./config/config;
      };
    };
  };
}
