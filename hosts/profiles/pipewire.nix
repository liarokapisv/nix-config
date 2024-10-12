{ self, pkgs, ... }: {

  security.rtkit.enable = true;

  services = {
    pipewire = {
      enable = true;
      alsa.enable = true;
      jack.enable = true;
      pulse.enable = true;

      # TODO: Fix when fixed upstream.
      wireplumber.configPackages = [
        (pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/10-disable-webcam.conf" ''
          wireplumber.profiles = {
            main = {
              monitor.libcamera = disabled
            }
          }
        '')
      ];
    };

  };

  users.users.${self.user} = {
    extraGroups = [ "pipewire" ];
  };

  home-manager.users.${self.user} = {
    imports = [
      ../../homes/profiles/pipewire.nix
    ];
  };
}

