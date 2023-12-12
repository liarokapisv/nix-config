{ config, lib, ... }: {

  options = {
    dotfiles.ssh.enable = lib.mkEnableOption "ssh";
  };

  config = lib.mkIf (config.dotfiles.ssh.enable) {
    programs = {
      ssh = {
        enable = true;
        extraConfig = builtins.readFile ./config/config;
      };
    };
  };
}
