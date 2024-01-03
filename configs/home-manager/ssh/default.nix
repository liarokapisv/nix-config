{ config, lib, ... }:

lib.mkIf (config.programs.ssh.enable) {
  programs = {
    ssh = {
      extraConfig = builtins.readFile ./config;
    };
  };
}
