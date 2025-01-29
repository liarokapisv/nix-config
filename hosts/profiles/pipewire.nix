{ self, ... }: {

  security.rtkit.enable = true;

  services = {
    pipewire = {
      enable = true;
      alsa.enable = true;
      jack.enable = true;
      pulse.enable = true;
    };

  };

  users.users.${self.user} = { extraGroups = [ "pipewire" ]; };

  home-manager.users.${self.user} = {
    imports = [ ../../homes/profiles/pipewire.nix ];
  };
}

